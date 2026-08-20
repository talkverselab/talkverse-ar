import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_config.dart';
import '../data/word_data.dart';
import '../data/user_progress.dart';
import '../data/user_stats.dart';
import '../models/word.dart';
import '../services/audio_playback_service.dart';
import '../services/language_service.dart';
import '../services/learning_preferences.dart';
import '../services/tts_service.dart';
import '../theme/app_colors.dart';
import '../widgets/marked_text.dart';
import '../widgets/memo_editor.dart';
import 'package:talkverse/flavors/ru/widgets/russian_morph_text.dart';
import '../widgets/stressed_romanization.dart';
import '../widgets/upgrade_banner.dart';
import 'flashcard_screen.dart';

/// 회화 공부 화면 — 카테고리당 두 가지 표시 모드:
///   * 카테고리 안에 dialogue 항목(speaker A/B)이 있으면 → 채팅 풍선 뷰
///   * 그 외 카테고리(단발 표현 모음) → 기존 PhraseCard 리스트 뷰
class ConversationScreen extends StatefulWidget {
  final int? course;
  /// AdultHubScreen 등에서 특정 카테고리로 진입할 때 자동 선택할 탭 라벨.
  final String? initialCategory;
  /// 부록(appendix) 언어 표시용 override. null이면 현재 활성 언어만.
  /// 예: id에서 말레이어 부록 진입 시 langCode='ms' 전달.
  final String? langCode;
  const ConversationScreen(
      {super.key, this.course, this.initialCategory, this.langCode});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  late String selectedCategory;
  late List<Word> pool;
  late List<String> categories;

  @override
  void initState() {
    super.initState();
    final all = conversationPool();
    // 언어 prefix 필터: 지정된 부록 언어 or 메인 언어만 (부록 rows 제외).
    final langPrefix =
        '${widget.langCode ?? AppConfig.languageCode}:';
    final langFiltered =
        all.where((w) => w.id.startsWith(langPrefix)).toList();
    pool = widget.course == null
        ? langFiltered
        : langFiltered.where((w) => w.course == widget.course).toList();
    // 대화 그룹부터, 그다음 단발 카테고리. 같은 그룹 내에선 알파벳 순.
    // 대화 카테고리: '대화16', '대화17'... 자연 정렬 (숫자 오름차순).
    final dialogueCats = pool
        .where((w) => w.isDialogue)
        .map((w) => w.category)
        .toSet()
        .toList()
      ..sort();
    // 표현 카테고리: 빈도순 — 항목 수가 많은 카테고리(=자주 쓰임)가 먼저.
    // 사용자 피드백: 알파벳순이 아니라 실용 빈도 기준으로.
    final phraseCounts = <String, int>{};
    for (final w in pool.where((w) => !w.isDialogue)) {
      phraseCounts.update(w.category, (n) => n + 1, ifAbsent: () => 1);
    }
    final phraseCats = phraseCounts.keys.toList()
      ..sort((a, b) => phraseCounts[b]!.compareTo(phraseCounts[a]!));
    // 숫자/날짜처럼 무미건조한 카테고리는 뒤로 — 질리지 않도록.
    bool isBoringCat(String c) =>
        c.contains('숫자') || c.contains('날짜') || c.contains('시간 표현');
    final phraseFun = phraseCats.where((c) => !isBoringCat(c)).toList();
    final phraseBoring = phraseCats.where(isBoringCat).toList();
    categories = [...dialogueCats, ...phraseFun, ...phraseBoring];
    // initialCategory 지정 + 카테고리 목록에 존재하면 그것을 기본 탭으로.
    if (widget.initialCategory != null &&
        categories.contains(widget.initialCategory)) {
      selectedCategory = widget.initialCategory!;
    } else {
      selectedCategory = categories.isNotEmpty ? categories.first : '';
    }
    // 부록 언어로 진입 시 TTS locale 도 일시 전환.
    if (widget.langCode != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        TtsService.instance.setLanguageOverride(widget.langCode);
      });
    }
  }

  @override
  void dispose() {
    TtsService.instance.stop();
    if (widget.langCode != null) {
      TtsService.instance.setLanguageOverride(null);
    }
    super.dispose();
  }

  bool _isDialogueCategory(String cat) =>
      pool.any((w) => w.category == cat && w.isDialogue);

  List<Word> _itemsFor(String cat) {
    final items = pool.where((w) => w.category == cat).toList();
    if (_isDialogueCategory(cat)) {
      items.sort((a, b) => a.turnOrder.compareTo(b.turnOrder));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final items = _itemsFor(selectedCategory);
    final isDialogue = _isDialogueCategory(selectedCategory);
    final scenario =
        isDialogue && items.isNotEmpty ? items.first.scenario : '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
            widget.course == null
                ? '💬 회화 공부'
                : '💬 ${AppConfig.courseDisplayName(widget.course!)}',
            style: GoogleFonts.notoSans(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          // 한글만 — ON 이면 원문·독음 전부 숨기고 뜻만 표시.
          ValueListenableBuilder<bool>(
            valueListenable:
                LearningPreferences.instance.conversationKoreanOnly,
            builder: (context, koOnly, _) {
              return IconButton(
                onPressed: () =>
                    LearningPreferences.instance.toggleKoreanOnly(),
                icon: Icon(koOnly
                    ? Icons.translate
                    : Icons.translate_outlined),
                color:
                    koOnly ? AppConfig.brandColor : AppColors.textMuted,
                tooltip: koOnly ? '한국어만 (원문 숨김)' : '한국어만 보기',
              );
            },
          ),
          // 한글 독음(romanization) — 원문·뜻 아래 독음 줄.
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
          // RU 굴절 색칠 토글 — RU 일 때만 노출.
          ValueListenableBuilder<String>(
            valueListenable: LanguageService.instance.code,
            builder: (context, lang, _) {
              if (lang != 'ru') return const SizedBox.shrink();
              return ValueListenableBuilder<bool>(
                valueListenable:
                    LearningPreferences.instance.showMorphColors,
                builder: (context, on, _) {
                  return IconButton(
                    onPressed: () =>
                        LearningPreferences.instance.toggleMorphColors(),
                    icon: Icon(on ? Icons.palette : Icons.palette_outlined),
                    color: on
                        ? AppConfig.brandColor
                        : AppColors.textMuted,
                    tooltip: '굴절 색칠 ${on ? "끄기" : "켜기"}',
                  );
                },
              );
            },
          ),
          // 슬로우 오디오 토글 — 사전 생성 mp3 (Azure) 가 있는 언어 (현재 MN) 만 노출.
          ValueListenableBuilder<String>(
            valueListenable: LanguageService.instance.code,
            builder: (context, lang, _) {
              if (!AudioPlaybackService.supportedLangs.contains(lang)) {
                return const SizedBox.shrink();
              }
              return ValueListenableBuilder<bool>(
                valueListenable: LearningPreferences.instance.slowAudio,
                builder: (context, slow, _) {
                  return IconButton(
                    onPressed: () =>
                        LearningPreferences.instance.toggleSlowAudio(),
                    icon: Icon(slow ? Icons.slow_motion_video : Icons.speed),
                    color: slow
                        ? AppConfig.brandColor
                        : AppColors.textMuted,
                    tooltip: slow ? '느린 발음 (-20%)' : '정상 속도',
                  );
                },
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          UpgradeBanner(
            lockedCount: premiumLockedCount(conversation: true),
          ),
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: categories.map((category) {
                final isSelected = selectedCategory == category;
                final dialogue = _isDialogueCategory(category);
                return GestureDetector(
                  onTap: () => setState(() => selectedCategory = category),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.purple
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.purple
                            : AppColors.cardBorder,
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (dialogue) ...[
                            Icon(Icons.chat_bubble_outline,
                                size: 12,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            category,
                            style: GoogleFonts.notoSans(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          if (isDialogue && scenario.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.purple.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.purple.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.theater_comedy,
                        size: 16, color: AppColors.purple),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        scenario,
                        style: GoogleFonts.notoSans(
                          fontSize: 12,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text('데이터 없음',
                        style: TextStyle(color: AppColors.textSecondary)))
                : isDialogue
                    ? _DialogueView(items: items)
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: items.length,
                        itemBuilder: (context, index) =>
                            _PhraseCard(word: items[index]),
                      ),
          ),
          // 암기하기 — 이 대화 라인들을 플래시카드 덱으로 넘김.
          // 사용자 피드백: 대화문이 먼저 보이고, 암기 버튼은 화면 하단에.
          if (isDialogue && items.isNotEmpty)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FlashCardScreen(
                            course: items.first.course,
                            initialCategory: items.first.category,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.style, size: 20),
                    label: Text(
                      '이 대화 암기하기 (플래시카드)',
                      style: GoogleFonts.notoSans(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 채팅 풍선 형태로 대화 스크립트 표시.
class _DialogueView extends StatelessWidget {
  final List<Word> items;
  const _DialogueView({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final w = items[i];
        return _BubbleRow(word: w);
      },
    );
  }
}

class _BubbleRow extends StatelessWidget {
  final Word word;
  const _BubbleRow({required this.word});

  @override
  Widget build(BuildContext context) {
    final isA = word.speaker == 'A';
    final bubbleColor =
        isA ? Colors.white : AppConfig.brandColor.withValues(alpha: 0.12);
    final borderColor = isA
        ? AppColors.cardBorder
        : AppConfig.brandColor.withValues(alpha: 0.4);
    // 격변화 색 + 명사 성별 밑줄. parseMarkers 가 {nom:...}, {nom,masc:...}
    // 같은 콤비도 그대로 해석.
    // v17: vi 호칭 placeholder 치환된 텍스트로 marker parsing.
    final segments = parseMarkers(word.targetForCurrent);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment:
            isA ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isA) _SpeakerBadge(label: 'A', word: word),
          if (isA) const SizedBox(width: 8),
          Flexible(
            child: GestureDetector(
              onTap: () {
                TtsService.instance.speak(word.targetPlainForCurrent, speaker: word.speaker, itemId: word.id);
                UserStats().recordActivity(isSentence: true);
              },
              onLongPress: () => showMemoEditor(context, word),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(14),
                    topRight: const Radius.circular(14),
                    bottomLeft: Radius.circular(isA ? 4 : 14),
                    bottomRight: Radius.circular(isA ? 14 : 4),
                  ),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: ValueListenableBuilder<bool>(
                  valueListenable:
                      LearningPreferences.instance.conversationKoreanOnly,
                  builder: (context, koOnly, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!koOnly)
                          _TargetText(
                            word: word,
                            segments: segments,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        if (!koOnly)
                          ValueListenableBuilder<bool>(
                            valueListenable: LearningPreferences
                                .instance.showRomanization,
                            builder: (context, showRom, _) {
                              final rom = word.romanizationForCurrent;
                              if (!showRom || rom.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: StressedRomanization(
                                  rom,
                                  style: GoogleFonts.notoSans(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              );
                            },
                          ),
                        if (!koOnly) const SizedBox(height: 4),
                        Text(
                          word.korean,
                          style: GoogleFonts.notoSans(
                            fontSize: koOnly ? 16 : 13,
                            fontWeight: koOnly
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (word.notes.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            '💡 ${word.notes}',
                            style: GoogleFonts.notoSans(
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          if (!isA) const SizedBox(width: 8),
          if (!isA) _SpeakerBadge(label: 'B', word: word),
        ],
      ),
    );
  }
}

class _SpeakerBadge extends StatelessWidget {
  final String label;
  final Word word;
  const _SpeakerBadge({required this.label, required this.word});

  @override
  Widget build(BuildContext context) {
    final color =
        label == 'A' ? AppColors.success : AppConfig.brandColor;
    return GestureDetector(
      onTap: () => TtsService.instance.speak(word.targetPlainForCurrent, speaker: label, itemId: word.id),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: const Icon(Icons.volume_up, color: Colors.white, size: 16),
      ),
    );
  }
}

class _PhraseCard extends StatefulWidget {
  final Word word;
  const _PhraseCard({required this.word});

  @override
  State<_PhraseCard> createState() => _PhraseCardState();
}

class _PhraseCardState extends State<_PhraseCard> {
  bool expanded = false;

  bool _isNewEffective() =>
      widget.word.hasTag('new') && !UserProgress().isKnown(widget.word.id);

  void _showSegmentInfo(TextSegment seg) {
    final parts = <String>[];
    if (seg.caseTag != null) {
      parts.add('${AppConfig.grammarTagNames[seg.caseTag]} (${seg.caseTag})');
    }
    if (seg.isNew) parts.add('새 단어');
    if (parts.isEmpty) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${seg.text.trim()} → ${parts.join(' · ')}',
            style: GoogleFonts.notoSans(color: Colors.white)),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.textPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<StudyDirection>(
      valueListenable: LearningPreferences.instance.direction,
      builder: (context, direction, _) {
        final koreanFirst = direction == StudyDirection.koreanFirst;
        final segments = parseMarkers(widget.word.targetForCurrent);
        final isNew = _isNewEffective();

        return GestureDetector(
          onTap: () {
            setState(() => expanded = !expanded);
            if (expanded) {
              UserStats().recordActivity(isSentence: true);
              TtsService.instance.speak(widget.word.targetPlainForCurrent, itemId: widget.word.id);
            }
          },
          onLongPress: () => showMemoEditor(context, widget.word),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isNew
                    ? AppColors.newHighlightBorder
                    : (expanded ? AppColors.purple : AppColors.cardBorder),
                width: isNew ? 2 : (expanded ? 2 : 1.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: koreanFirst
                          ? _koreanFront(widget.word)
                          : _targetFront(widget.word, segments),
                    ),
                    IconButton(
                      onPressed: () => TtsService.instance
                          .speak(widget.word.targetPlainForCurrent),
                      icon: const Icon(Icons.volume_up),
                      color: AppConfig.brandColor,
                      tooltip: '발음 듣기',
                    ),
                    Icon(
                      expanded ? Icons.expand_less : Icons.expand_more,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
                if (expanded) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: koreanFirst
                        ? _targetFront(widget.word, segments)
                        : Text(
                            widget.word.korean,
                            style: GoogleFonts.notoSans(
                              fontSize: 15,
                              color: AppColors.textPrimary,
                            ),
                          ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _koreanFront(Word w) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          w.korean,
          style: GoogleFonts.notoSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        if (w.notes.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            '💡 ${w.notes}',
            style: GoogleFonts.notoSans(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ],
    );
  }

  Widget _targetFront(Word w, List<TextSegment> segments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TargetText(
          word: w,
          segments: segments,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          onSegmentTap: _showSegmentInfo,
        ),
        ValueListenableBuilder<bool>(
          valueListenable: LearningPreferences.instance.showRomanization,
          builder: (context, showRom, _) {
            final rom = w.romanizationForCurrent;
            if (!showRom || rom.isEmpty) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(top: 4),
              child: StressedRomanization(
                rom,
                style: GoogleFonts.notoSans(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            );
          },
        ),
        if (w.notes.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            '💡 ${w.notes}',
            style: GoogleFonts.notoSans(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ],
    );
  }
}

/// 회화 화면용 target text 렌더 — RU 면 morph_tags 기반 색칠,
/// 그 외 언어는 기존 MarkedText (gender/case 밑줄) 로 폴백.
/// 토글 OFF 또는 morph_tags NULL 일 때도 MarkedText 로 폴백.
class _TargetText extends StatelessWidget {
  final Word word;
  final List<TextSegment> segments;
  final double fontSize;
  final FontWeight fontWeight;
  final void Function(TextSegment)? onSegmentTap;

  const _TargetText({
    required this.word,
    required this.segments,
    required this.fontSize,
    required this.fontWeight,
    this.onSegmentTap,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: LanguageService.instance.code,
      builder: (context, lang, _) {
        if (lang == 'ru' && word.morphTags != null && word.morphTags!.isNotEmpty) {
          return ValueListenableBuilder<bool>(
            valueListenable: LearningPreferences.instance.showMorphColors,
            builder: (context, on, _) {
              if (!on) {
                return MarkedText(
                  segments: segments,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  onSegmentTap: onSegmentTap,
                );
              }
              return RussianMorphText(
                morphTagsJson: word.morphTags,
                fallbackText: word.targetForCurrent,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  color: AppColors.textPrimary,
                ),
              );
            },
          );
        }
        return MarkedText(
          segments: segments,
          fontSize: fontSize,
          fontWeight: fontWeight,
          onSegmentTap: onSegmentTap,
        );
      },
    );
  }
}
