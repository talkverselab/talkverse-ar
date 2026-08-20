import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_config.dart';
import '../data/hanzi_study.dart';
import '../data/word_data.dart';
import '../db/app_database.dart' hide UserStats, UserProgress;
import '../supabase/supabase_service.dart';
import '../data/favorite_words.dart';
import '../data/user_progress.dart';
import '../data/user_stats.dart';
import '../data/word_reviews.dart';
import '../models/word.dart';
import '../services/learning_preferences.dart';
import '../services/tts_service.dart';
import '../theme/app_colors.dart';
import '../widgets/marked_text.dart';
import '../widgets/memo_editor.dart';
import '../widgets/stressed_romanization.dart';
import '../widgets/upgrade_banner.dart';
import 'hanzi_detail_screen.dart';

class FlashCardScreen extends StatefulWidget {
  final bool reviewMode;
  final bool favoritesMode;
  final int? course;
  /// 성인 허브처럼 카테고리를 미리 결정하고 진입할 때 사용.
  /// null이면 카테고리 드롭다운 기본값("전체")에서 시작.
  final String? initialCategory;
  /// 부록(appendix) 언어 override — 예: 'lo'. null 이면 주 언어.
  /// pool 을 ID prefix 로 한정 + TTS locale 일시 전환.
  final String? languageOverride;
  const FlashCardScreen({
    super.key,
    this.reviewMode = false,
    this.favoritesMode = false,
    this.course,
    this.initialCategory,
    this.languageOverride,
  });

  @override
  State<FlashCardScreen> createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
  int currentIndex = 0;
  bool isFlipped = false;
  /// Session counter — incremented on 알아요. Doubles as the "알아요"
  /// number in the 알아요/배우는중/전체 header.
  int score = 0;
  /// Session counter — incremented on 배우는 중 (no DB write, just for UX).
  int learningCount = 0;
  String selectedCategory = '전체';

  /// Undo stack — one entry per 몰라요/배우는중/알아요 press, used by the
  /// "이전 단어" button to roll back both the session counter and any DB
  /// write that came with the action.
  final List<_CardAction> _history = [];

  final UserProgress progress = UserProgress();
  final WordReviews reviews = WordReviews();
  final FavoriteWords favorites = FavoriteWords();

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      selectedCategory = widget.initialCategory!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 부록 언어 override 시 TTS locale 도 일시 전환 (예: lo-LA).
      await TtsService.instance.setLanguageOverride(widget.languageOverride);
      _autoSpeakIfRussianVisible();
    });
  }

  @override
  void dispose() {
    TtsService.instance.stop();
    if (widget.languageOverride != null) {
      TtsService.instance.setLanguageOverride(null);
    }
    super.dispose();
  }

  /// Whether the Russian side of the card is currently visible to the user.
  /// In ko→러 mode: front is Korean, Russian shows when flipped.
  /// In 러→ko mode: front is Russian.
  bool get _isRussianVisible {
    final koreanFirst =
        LearningPreferences.instance.direction.value ==
            StudyDirection.koreanFirst;
    return koreanFirst ? isFlipped : !isFlipped;
  }

  /// Always speak — used by the manual 🔊 button.
  void _speakCurrent() {
    final words = filteredWords;
    if (words.isEmpty) return;
    final word = words[currentIndex % words.length];
    TtsService.instance.speak(word.targetPlainForCurrent, itemId: word.id);
  }

  /// Auto-play only when Russian is on the visible side.
  /// Keeps the Korean-first prompt pure (user must recall before hearing).
  void _autoSpeakIfRussianVisible() {
    if (!_isRussianVisible) {
      TtsService.instance.stop();
      return;
    }
    _speakCurrent();
  }

  List<Word> get pool => flashcardPool();

  List<Word> get filteredWords {
    List<Word> scoped = pool;
    final lang = widget.languageOverride;
    if (lang != null) {
      scoped = scoped.where((w) => w.id.startsWith('$lang:')).toList();
    }
    if (widget.course != null) {
      scoped = scoped.where((w) => w.course == widget.course).toList();
    }
    if (selectedCategory != '전체') {
      scoped = scoped.where((w) => w.category == selectedCategory).toList();
    }
    if (widget.reviewMode) {
      // 복습 pool = 망각곡선으로 due인 단어 ∪ 다시 외우기(즐겨찾기).
      // 둘 중 하나라도 해당하면 복습 대상.
      scoped = scoped
          .where((w) =>
              reviews.isDueForReview(w.id) || favorites.isFavorite(w.id))
          .toList();
    }
    if (widget.favoritesMode) {
      scoped = scoped.where((w) => favorites.isFavorite(w.id)).toList();
    }
    return reviews.prioritize(scoped);
  }

  bool _isNew(Word w) => w.hasTag('new') && !progress.isKnown(w.id);

  @override
  Widget build(BuildContext context) {
    final words = filteredWords;
    final screenTitle = widget.favoritesMode
        ? '⭐ 다시 외우기'
        : widget.reviewMode
            ? '🔄 복습하기'
            : widget.course != null
                ? '📚 ${AppConfig.courseDisplayName(widget.course!)}'
                : '📚 단어 외우기';

    if (words.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: AppColors.textPrimary,
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(screenTitle,
              style: GoogleFonts.notoSans(
                  color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🎉', style: TextStyle(fontSize: 56)),
                const SizedBox(height: 12),
                Text(
                  widget.favoritesMode
                      ? '즐겨찾기한 단어가 없어요'
                      : widget.reviewMode
                          ? '복습할 단어가 없어요!'
                          : '학습할 단어가 없어요.',
                  style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.favoritesMode
                      ? '플래시카드에서 하트를 눌러 추가하세요'
                      : widget.reviewMode
                          ? '모든 단어를 잘 외우고 계세요.'
                          : '카테고리를 변경해보세요.',
                  style: GoogleFonts.notoSans(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      );
    }
    final word = words[currentIndex % words.length];
    final segments = parseMarkers(word.targetForCurrent);
    final isSentence = word.type != ItemType.word;

    final categoryOptions = [
      '전체',
      ...pool.map((w) => w.category).toSet().toList()..sort(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.textPrimary,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(screenTitle,
            style: GoogleFonts.notoSans(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: LearningPreferences.instance.showRomanization,
            builder: (context, showRom, _) {
              return IconButton(
                onPressed: () =>
                    LearningPreferences.instance.toggleRomanization(),
                icon: Icon(showRom ? Icons.subtitles : Icons.subtitles_off),
                color: showRom
                    ? AppConfig.brandColor
                    : AppColors.textMuted,
                tooltip: '한글 독음 ${showRom ? "끄기" : "켜기"}',
              );
            },
          ),
          ValueListenableBuilder<StudyDirection>(
            valueListenable: LearningPreferences.instance.direction,
            builder: (context, dir, _) {
              final label = dir == StudyDirection.koreanFirst
                  ? '한 → 러'
                  : '러 → 한';
              return TextButton.icon(
                onPressed: () async {
                  await LearningPreferences.instance.toggle();
                  setState(() => isFlipped = false);
                  _autoSpeakIfRussianVisible();
                },
                icon: const Icon(Icons.swap_horiz, size: 18),
                label: Text(label,
                    style: GoogleFonts.notoSans(
                        fontSize: 12, fontWeight: FontWeight.bold)),
                style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary),
              );
            },
          ),
          if (!widget.reviewMode)
            DropdownButton<String>(
            value: categoryOptions.contains(selectedCategory)
                ? selectedCategory
                : '전체',
            dropdownColor: Colors.white,
            style: const TextStyle(color: AppColors.textPrimary),
            underline: const SizedBox(),
            items: categoryOptions.map((cat) {
              return DropdownMenuItem<String>(value: cat, child: Text(cat));
            }).toList(),
            onChanged: (val) {
              setState(() {
                selectedCategory = val!;
                currentIndex = 0;
                isFlipped = false;
              });
              _autoSpeakIfRussianVisible();
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          UpgradeBanner(
            lockedCount: premiumLockedCount(conversation: false),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${(currentIndex % words.length) + 1} / ${words.length}',
                        style: GoogleFonts.notoSans(
                            color: AppColors.textSecondary),
                      ),
                      // 알아요 / 배우는 중 / 전체 (세션 카운트)
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.notoSans(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                                text: '$score',
                                style: const TextStyle(
                                    color: AppColors.successDark)),
                            TextSpan(
                                text: ' / ',
                                style: GoogleFonts.notoSans(
                                    color: AppColors.textMuted,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13)),
                            TextSpan(
                                text: '$learningCount',
                                style: const TextStyle(
                                    color: AppColors.warning)),
                            TextSpan(
                                text: ' / ',
                                style: GoogleFonts.notoSans(
                                    color: AppColors.textMuted,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13)),
                            TextSpan(
                                text: '${words.length}',
                                style: const TextStyle(
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                setState(() => isFlipped = !isFlipped);
                _autoSpeakIfRussianVisible();
              },
              onLongPress: () => showMemoEditor(context, word),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                height: 260,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isFlipped ? AppConfig.brandColor : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _isNew(word)
                        ? AppColors.newHighlightBorder
                        : (isFlipped
                            ? AppConfig.brandColor
                            : AppColors.cardBorder),
                    width: _isNew(word) ? 3 : 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: ValueListenableBuilder<StudyDirection>(
                    valueListenable:
                        LearningPreferences.instance.direction,
                    builder: (context, direction, _) {
                      final showKorean =
                          direction == StudyDirection.koreanFirst
                              ? !isFlipped
                              : isFlipped;
                      final showHint = !isFlipped && word.notes.isNotEmpty;
                      if (showKorean) {
                        return _koreanSide(word, showHint: showHint);
                      }
                      return _targetSide(
                        word,
                        segments,
                        isSentence,
                        showHint: showHint,
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('탭하면 뒤집기 👆',
                    style: GoogleFonts.notoSans(
                        color: AppColors.textMuted, fontSize: 13)),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: _speakCurrent,
                  icon: const Icon(Icons.volume_up),
                  color: AppConfig.brandColor,
                  tooltip: '발음 듣기',
                ),
                IconButton(
                  onPressed: () async {
                    await favorites.toggle(word.id);
                    setState(() {});
                  },
                  icon: Icon(favorites.isFavorite(word.id)
                      ? Icons.favorite
                      : Icons.favorite_border),
                  color: favorites.isFavorite(word.id)
                      ? AppColors.danger
                      : AppColors.textMuted,
                  tooltip: '다시 외우기',
                ),
              ],
            ),
            if (word.relatedTexts.isNotEmpty) ...[
              const SizedBox(height: 12),
              _RelatedRow(tokens: word.relatedTexts),
            ],
            const SizedBox(height: 8),
            // "이전 단어" 버튼 — 관련단어 row 아래, 액션 버튼 위.
            // 기록이 비어 있어도 탭 가능 (안내 SnackBar 표시).
            Center(
              child: TextButton.icon(
                onPressed: () {
                  if (_history.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('이전 단어가 없어요',
                            style: GoogleFonts.notoSans(color: Colors.white)),
                        backgroundColor: AppColors.textPrimary,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                    return;
                  }
                  _undoLast(words.length);
                },
                icon: Icon(Icons.undo,
                    size: 18,
                    color: _history.isEmpty
                        ? AppColors.textMuted
                        : AppConfig.brandColor),
                label: Text(
                  _history.isEmpty
                      ? '이전 단어 없음'
                      : '이전 단어로 (${_history.length})',
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _history.isEmpty
                        ? AppColors.textMuted
                        : AppConfig.brandColor,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: _actionButton(
                    label: '❌ 몰라요',
                    color: AppColors.danger,
                    onTap: () async {
                      _pushHistory(word, _CardActionType.unknown);
                      await reviews.recordUnknown(word.id);
                      UserStats()
                          .recordActivity(isSentence: word.type != ItemType.word);
                      setState(() {
                        isFlipped = false;
                        currentIndex = (currentIndex + 1) % words.length;
                      });
                      _autoSpeakIfRussianVisible();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  // "배우는 중" — no DB write, no stage change. The item
                  // stays at whatever stage it was, keeps its schedule,
                  // and reappears when the deck cycles.
                  child: _actionButton(
                    label: '🔄 배우는 중',
                    color: AppColors.warning,
                    onTap: () {
                      _pushHistory(word, _CardActionType.learning);
                      UserStats()
                          .recordActivity(isSentence: word.type != ItemType.word);
                      setState(() {
                        learningCount++;
                        isFlipped = false;
                        currentIndex = (currentIndex + 1) % words.length;
                      });
                      _autoSpeakIfRussianVisible();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _actionButton(
                    label: '✅ 알아요',
                    color: AppColors.success,
                    onTap: () async {
                      _pushHistory(word, _CardActionType.known);
                      await progress.markKnown(word.id);
                      await reviews.recordKnown(word.id);
                      await UserStats()
                          .recordActivity(isSentence: word.type != ItemType.word);
                      setState(() {
                        score++;
                        isFlipped = false;
                        currentIndex = (currentIndex + 1) % words.length;
                      });
                      _autoSpeakIfRussianVisible();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
          ),
        ],
      ),
    );
  }

  Widget _koreanSide(Word w, {required bool showHint}) {
    final color = isFlipped ? Colors.white : AppColors.textPrimary;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          w.korean,
          textAlign: TextAlign.center,
          style: GoogleFonts.notoSans(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        if (showHint) _hintText(w.notes, onLight: true),
      ],
    );
  }

  Widget _targetSide(Word w, List<TextSegment> segments, bool isSentence,
      {required bool showHint}) {
    // On the "back" side (isFlipped), the card bg is brand blue → use white text.
    final onDarkBackground = isFlipped;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MarkedText(
          segments: segments,
          fontSize: isSentence ? 24 : 42,
          fontWeight: FontWeight.bold,
          defaultColor:
              onDarkBackground ? Colors.white : AppColors.textPrimary,
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<bool>(
          valueListenable: LearningPreferences.instance.showRomanization,
          builder: (context, showRom, _) {
            final rom = w.romanizationForCurrent;
            if (!showRom || rom.isEmpty) {
              return const SizedBox.shrink();
            }
            return StressedRomanization(
              rom,
              style: GoogleFonts.notoSans(
                fontSize: 14,
                color: onDarkBackground
                    ? Colors.white.withValues(alpha: 0.85)
                    : AppColors.textSecondary,
              ),
            );
          },
        ),
        if (showHint) _hintText(w.notes, onLight: !onDarkBackground),
        if (!onDarkBackground) ...[
          const SizedBox(height: 12),
          _metaBadges(w),
        ],
        // Root/etymon chips — 한자(zh/ja/ko)든 라틴/그리스/게르만/아랍 어근이든
        // items.root_refs CSV 하나로 통합. CJK 단어는 target_text 의 한자도 자동 추가.
        const SizedBox(height: 12),
        _RootChipRow(word: w, onDark: onDarkBackground),
      ],
    );
  }

  Widget _hintText(String hint, {required bool onLight}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        '💡 $hint',
        textAlign: TextAlign.center,
        style: GoogleFonts.notoSans(
          fontSize: 12,
          fontStyle: FontStyle.italic,
          color: onLight
              ? AppColors.textMuted
              : Colors.white.withValues(alpha: 0.75),
        ),
      ),
    );
  }

  Widget _metaBadges(Word w) {
    return Wrap(
      spacing: 8,
      children: [
        _badge(w.category, AppColors.surface, AppColors.textSecondary),
        _badge(AppConfig.courseDisplayName(w.course), AppColors.surface,
            AppColors.textSecondary),
        if (_isNew(w))
          _badge('새 단어', AppColors.newHighlight, AppColors.textPrimary),
      ],
    );
  }

  Widget _badge(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text,
          style: GoogleFonts.notoSans(
              color: fg, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  /// Snapshot the word's pre-action state so [_undoLast] can revert it.
  void _pushHistory(Word w, _CardActionType type) {
    _history.add(_CardAction(
      wordId: w.id,
      type: type,
      prevStage: reviews.stageOf(w.id),
      prevNextReviewAt: reviews.dueAt(w.id),
      prevIsKnown: progress.isKnown(w.id),
    ));
  }

  /// Undo the most recent 몰라요/배우는중/알아요 press: rewind the deck by
  /// one step AND revert that word's progress/review state + session counter.
  Future<void> _undoLast(int deckLen) async {
    if (_history.isEmpty) return;
    final last = _history.removeLast();

    // Revert session counters.
    if (last.type == _CardActionType.known && score > 0) score--;
    if (last.type == _CardActionType.learning && learningCount > 0) {
      learningCount--;
    }

    // Revert UserProgress.isKnown if 알아요 flipped it from false→true.
    if (last.type == _CardActionType.known &&
        !last.prevIsKnown &&
        progress.isKnown(last.wordId)) {
      await progress.unmarkKnown(last.wordId);
    }

    // Revert forgetting-curve stage + schedule. 배우는 중 didn't touch
    // these but restoreTo is a no-op in that case (prev == current).
    await reviews.restoreTo(
        last.wordId, last.prevStage, last.prevNextReviewAt);

    setState(() {
      isFlipped = false;
      currentIndex = (currentIndex - 1 + deckLen) % deckLen;
    });
    _autoSpeakIfRussianVisible();
  }

  Widget _actionButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(label,
              style: GoogleFonts.notoSans(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

/// 이전 단어로 되돌리기(undo)용 스냅샷. 각 액션 버튼 누르기 직전에
/// 푸시해두고, "이전 단어" 버튼에서 pop하여 DB와 세션 카운터를 복구.
enum _CardActionType { known, unknown, learning }

class _CardAction {
  final String wordId;
  final _CardActionType type;
  final int prevStage;
  final DateTime? prevNextReviewAt;
  final bool prevIsKnown;

  _CardAction({
    required this.wordId,
    required this.type,
    required this.prevStage,
    required this.prevNextReviewAt,
    required this.prevIsKnown,
  });
}

/// 플래시카드 하단 관련단어 row — 단일 행 1×N (N=1..4).
/// 높이는 메인 카드(260)의 약 절반(130)으로 고정.
class _RelatedRow extends StatelessWidget {
  final List<String> tokens;
  const _RelatedRow({required this.tokens});

  static const double _height = 130;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: Row(
        children: [
          for (var i = 0; i < tokens.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(child: _RelatedCard(token: tokens[i])),
          ],
        ],
      ),
    );
  }
}

class _RelatedCard extends StatelessWidget {
  final String token;
  const _RelatedCard({required this.token});

  @override
  Widget build(BuildContext context) {
    final match = findByTargetText(token);
    final enabled = match != null;
    return GestureDetector(
      onTap: enabled ? () => _showRelatedSheet(context, match) : null,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: enabled
                ? AppConfig.brandColor.withValues(alpha: 0.4)
                : AppColors.divider,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                match?.targetPlainForCurrent ?? token,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.notoSans(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              if (match != null) ...[
                const SizedBox(height: 6),
                Text(
                  match.korean,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.notoSans(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 관련단어 탭 시 뜨는 상세 모달. 뒤집기 없이 정보만 보여줌.
void _showRelatedSheet(BuildContext context, Word w) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              w.targetPlainForCurrent,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSans(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: LearningPreferences.instance.showRomanization,
              builder: (context, showRom, _) {
                final rom = w.romanizationForCurrent;
                if (!showRom || rom.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: StressedRomanization(
                    rom,
                    style: GoogleFonts.notoSans(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              w.korean,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSans(
                fontSize: 18,
                color: AppColors.textPrimary,
              ),
            ),
            if (w.notes.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                '💡 ${w.notes}',
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSans(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

/// 어근/어원 통합 chip 줄.
///
/// 두 입력 소스를 하나의 줄에 합침:
///   1. `word.targetPlain` 안의 CJK 한자 (zh/ja/ko 자동 추출)
///   2. `word.rootRefs` CSV 의 각 토큰:
///      - 'han:X'  → hanja_master 참조, _HanjaChip
///      - 'lat:am' 'ar:k-t-b' 등 → etymon 참조, _EtymonChip
///
/// 둘 다 비어있으면 SizedBox.shrink. 다크(카드 뒤집힘) 배경에서도 가드 없이
/// 호출 — 칩 자체가 흰 배경에 진한 글자라 대비 충분.
class _RootChipRow extends StatelessWidget {
  final Word word;
  final bool onDark;
  const _RootChipRow({required this.word, this.onDark = false});

  // CJK Unified Ideographs: U+4E00 ~ U+9FFF
  static bool _isCjk(int codeUnit) =>
      codeUnit >= 0x4E00 && codeUnit <= 0x9FFF;

  List<String> _extractHanzi(String text) {
    final seen = <String>{};
    final out = <String>[];
    for (final rune in text.runes) {
      if (_isCjk(rune)) {
        final ch = String.fromCharCode(rune);
        if (seen.add(ch)) out.add(ch);
      }
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    // 1) CJK 한자 자동 추출 (CJK 지원 언어일 때만)
    final hanziFromText =
        AppConfig.hasHanjaSupport ? _extractHanzi(word.targetPlain) : const [];

    // 2) root_refs 파싱
    final refs = word.rootRefList;
    final hanRefs = <String>[];
    final etymonRefs = <String>[];
    for (final ref in refs) {
      if (ref.startsWith('han:')) {
        hanRefs.add(ref.substring(4));
      } else {
        etymonRefs.add(ref);
      }
    }

    // 최종 한자 세트: targetText 추출 + han: 참조 합침 (중복 제거)
    final allHanzi = <String>{...hanziFromText, ...hanRefs}.toList();

    if (allHanzi.isEmpty && etymonRefs.isEmpty) return const SizedBox.shrink();

    final labelColor =
        onDark ? Colors.white.withValues(alpha: 0.85) : AppColors.textMuted;
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Column(
        children: [
          Text('탭해서 어원 학습',
              style: GoogleFonts.notoSans(fontSize: 11, color: labelColor)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: [
              for (final c in allHanzi) _HanjaChip(character: c, onDark: onDark),
              for (final id in etymonRefs)
                _EtymonChip(etymonId: id, onDark: onDark),
            ],
          ),
        ],
      ),
    );
  }
}

class _HanjaChip extends StatefulWidget {
  final String character;
  final bool onDark;
  const _HanjaChip({required this.character, this.onDark = false});

  @override
  State<_HanjaChip> createState() => _HanjaChipState();
}

class _HanjaChipState extends State<_HanjaChip> {
  bool _checking = false;

  Future<void> _onTap() async {
    if (_checking) return;
    setState(() => _checking = true);
    // 1순위: hanzi_studies_zh 의 부수 학습(다이어그램+관련 한자) 조회.
    //   현재는 zh 데이터만 시드돼 있지만 ja 도 같은 글자가 매칭되면 사용 가능.
    final study = await HanziStudyRepo().findByRadical(widget.character);
    if (!mounted) return;
    if (study != null) {
      setState(() => _checking = false);
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => HanziDetailScreen(studyId: study.id)),
      );
      return;
    }
    // 2순위: hanja_master 에 한국 음/뜻 정보가 있으면 간단 시트로 표시.
    final db = SupabaseService.instance.db;
    final hanja = await db.hanjaByKor(widget.character) ??
        await db.hanjaByJaKanji(widget.character);
    if (!mounted) return;
    setState(() => _checking = false);
    if (hanja == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '"${widget.character}" 에 대한 한자 학습 콘텐츠가 아직 없어요',
              style: GoogleFonts.notoSans(color: Colors.white)),
          backgroundColor: AppColors.textPrimary,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    if (!mounted) return;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _HanjaQuickSheet(hanja: hanja),
    );
  }

  @override
  Widget build(BuildContext context) {
    // chip 배경은 항상 흰색 → 어두운 카드 위에서도 잘 보임.
    // 다크 카드 위에선 테두리만 살짝 밝게.
    final borderColor = widget.onDark
        ? Colors.white.withValues(alpha: 0.85)
        : AppConfig.brandColor.withValues(alpha: 0.5);
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        alignment: Alignment.center,
        child: _checking
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                widget.character,
                style: GoogleFonts.notoSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppConfig.brandColor,
                ),
              ),
      ),
    );
  }
}

/// 한자 부수 학습이 없을 때 띄우는 간단 시트 — hanja_master 의 한국 음/뜻 +
/// 다국어 자형 표기. 사용자 요청 형식: 큰 한자 아래 작게 "[훈] [음]".
class _HanjaQuickSheet extends StatelessWidget {
  final HanjaMasterRow hanja;
  const _HanjaQuickSheet({required this.hanja});

  @override
  Widget build(BuildContext context) {
    final variants = <String>[
      if (hanja.zhSimplified != null && hanja.zhSimplified != hanja.korHanja)
        '간체 ${hanja.zhSimplified}',
      if (hanja.zhTraditional != null &&
          hanja.zhTraditional != hanja.korHanja)
        '번체 ${hanja.zhTraditional}',
      if (hanja.jaKanji != null && hanja.jaKanji != hanja.korHanja)
        '日 ${hanja.jaKanji}',
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            hanja.korHanja,
            style: GoogleFonts.notoSans(
              fontSize: 96,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          // 사용자 요청 표기 예: "밭 전"
          Text(
            '${hanja.korMeaning} ${hanja.korSound}'.trim(),
            style: GoogleFonts.notoSans(
              fontSize: 16,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: [
              _badge(
                  '부수 ${hanja.radical.isEmpty ? "?" : hanja.radical}'),
              _badge('${hanja.strokeTotal}획'),
              if (hanja.korLevel.isNotEmpty)
                _badge('한자 ${hanja.korLevel}'),
              if (hanja.jlptLevel != null)
                _badge('JLPT ${hanja.jlptLevel}'),
              if (hanja.hskLevel != null) _badge('HSK ${hanja.hskLevel}'),
            ],
          ),
          if (variants.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              variants.join('  ·  '),
              style: GoogleFonts.notoSans(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            '※ 부수 다이어그램 학습 콘텐츠는 아직 없어요. 한자 마스터에서 정보만 표시.',
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSans(
              fontSize: 11,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Text(text,
            style: GoogleFonts.notoSans(
                fontSize: 11, color: AppColors.textSecondary)),
      );
}

/// 어원 chip — etymon.id 로부터 비동기 로드.
/// 매핑 없거나 카탈로그 미시드면 SizedBox.shrink.
class _EtymonChip extends StatefulWidget {
  final String etymonId;
  final bool onDark;
  const _EtymonChip({required this.etymonId, this.onDark = false});

  static const Map<String, String> _langLabel = {
    'lat': 'Lat', 'gr': 'Gr', 'gem': 'Gem', 'pie': 'PIE',
    'ar': 'Ar', 'sa': 'Skt', 'sl': 'Sla', 'fr': 'Fr', 'old_en': 'OE',
  };

  @override
  State<_EtymonChip> createState() => _EtymonChipState();
}

class _EtymonChipState extends State<_EtymonChip> {
  EtymonRow? _etymon;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final row = await SupabaseService.instance.db.etymonById(widget.etymonId);
    if (!mounted) return;
    setState(() => _etymon = row);
  }

  @override
  Widget build(BuildContext context) {
    final e = _etymon;
    if (e == null) return const SizedBox.shrink();
    final borderColor = widget.onDark
        ? Colors.white.withValues(alpha: 0.85)
        : AppConfig.brandColor.withValues(alpha: 0.5);
    return GestureDetector(
      onTap: () => _showSheet(context, e),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_EtymonChip._langLabel[e.sourceLang] ?? e.sourceLang,
                style: GoogleFonts.notoSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppConfig.brandColor)),
            const SizedBox(width: 4),
            Text(e.root,
                style: GoogleFonts.notoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
            const SizedBox(width: 6),
            Text(e.meaningKo,
                style: GoogleFonts.notoSans(
                    fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Future<void> _showSheet(BuildContext context, EtymonRow etymon) async {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _EtymonSheet(etymon: etymon),
    );
  }
}

class _EtymonSheet extends StatefulWidget {
  final EtymonRow etymon;
  const _EtymonSheet({required this.etymon});

  @override
  State<_EtymonSheet> createState() => _EtymonSheetState();
}

class _EtymonSheetState extends State<_EtymonSheet> {
  late Future<List<String>> _related;

  @override
  void initState() {
    super.initState();
    _related =
        SupabaseService.instance.db.itemsForRootRef(widget.etymon.id, limit: 24);
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.etymon;
    final lang = _EtymonChip._langLabel[e.sourceLang] ?? e.sourceLang;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppConfig.brandColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(lang,
                style: GoogleFonts.notoSans(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppConfig.brandColor)),
          ),
          const SizedBox(height: 10),
          Text(e.root,
              style: GoogleFonts.notoSans(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.0)),
          const SizedBox(height: 4),
          Text('${e.meaningKo}${e.meaningEn.isNotEmpty ? "  ·  ${e.meaningEn}" : ""}',
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSans(
                  fontSize: 14, color: AppColors.textSecondary)),
          if (e.notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(e.notes,
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSans(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    fontStyle: FontStyle.italic)),
          ],
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          Text('같은 어근을 쓰는 다른 단어',
              style: GoogleFonts.notoSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          FutureBuilder<List<String>>(
            future: _related,
            builder: (context, snap) {
              final ids = snap.data ?? const [];
              if (ids.isEmpty) {
                return Text('— 데모 매핑이 더 추가되면 여기 표시',
                    style: GoogleFonts.notoSans(
                        fontSize: 11, color: AppColors.textMuted));
              }
              return Wrap(
                spacing: 6,
                runSpacing: 6,
                alignment: WrapAlignment.center,
                children: [
                  for (final id in ids) _RelatedItemChip(itemId: id),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// 관련 단어 chip — item_id 에서 마지막 ':' 뒤 부분만 표시 (예: 'es:sentence:Te amo' → 'Te amo').
class _RelatedItemChip extends StatelessWidget {
  final String itemId;
  const _RelatedItemChip({required this.itemId});

  @override
  Widget build(BuildContext context) {
    final parts = itemId.split(':');
    final lang = parts.isNotEmpty ? parts[0] : '';
    final text = parts.length > 2 ? parts.sublist(2).join(':') : itemId;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(lang.toUpperCase(),
              style: GoogleFonts.notoSans(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMuted)),
          const SizedBox(width: 4),
          Text(text,
              style: GoogleFonts.notoSans(
                  fontSize: 12, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
