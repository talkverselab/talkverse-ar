import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';

import '../config/app_config.dart';
import '../data/favorite_words.dart';
import '../data/user_stats.dart';
import '../data/word_reviews.dart';
import '../models/chat_dialogue.dart';
import '../services/address_preference_service.dart';
import '../services/language_service.dart';
import '../theme/app_colors.dart';
import '../widgets/polaroid_card.dart';

/// 채팅 dialogue → 문장 외우기 (플래시카드 모드).
///
/// 한 dialogue의 turns 를 1턴씩 플래시카드로:
///   - 앞면: 한국어 문장
///   - 뒷면: 베트남어 + 한글 독음 + 어기조사 hint
/// 호칭 placeholder 자동 치환.
class ChatDialogueMemorizeScreen extends StatefulWidget {
  final ChatDialogue dialogue;
  final String theme; // 'chat' | 'dating' | 'travel' | 'business' (SRS 키 분리)
  const ChatDialogueMemorizeScreen({
    super.key,
    required this.dialogue,
    this.theme = 'chat',
  });

  @override
  State<ChatDialogueMemorizeScreen> createState() =>
      _ChatDialogueMemorizeScreenState();
}

class _ChatDialogueMemorizeScreenState
    extends State<ChatDialogueMemorizeScreen> {
  int _index = 0;
  bool _showBack = false;
  bool _showTones = true;
  final AudioPlayer _player = AudioPlayer();

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  /// 사용자 결정 2026-05-09: 플래시카드 vi 면 진입 시 자동 TTS + 탭 시 재생.
  Future<void> _playVi(ChatTurn t) async {
    final dialect = LanguageService.instance.viRegion.value;
    final gender =
        AddressPreferenceService.instance.ttsGenderForSpeaker(t.speaker);
    final assetPath =
        'audio/tts/vi/${dialect}_$gender/${widget.theme}_${widget.dialogue.id.toString().padLeft(2, '0')}_${t.turn.toString().padLeft(2, '0')}.mp3';
    try {
      await rootBundle.load('assets/$assetPath');
      await _player.stop();
      await _player.play(AssetSource(assetPath));
    } catch (_) {/* asset 없으면 silent */}
  }

  String _sub(String s) =>
      AddressPreferenceService.instance.substitute(s);

  String _itemId(int turn) =>
      'vi:${widget.theme}:${widget.dialogue.id.toString().padLeft(2, '0')}:${turn.toString().padLeft(2, '0')}';

  Future<void> _onKnown() async {
    final t = widget.dialogue.turns[_index];
    await WordReviews().recordKnown(_itemId(t.turn));
    await UserStats().recordActivity(isSentence: true);
    if (mounted) {
      await Future.delayed(const Duration(milliseconds: 200));
      _next();
    }
  }

  Future<void> _toggleFavorite() async {
    final t = widget.dialogue.turns[_index];
    await FavoriteWords().toggle(_itemId(t.turn));
    if (mounted) setState(() {});
  }

  void _flip() {
    setState(() => _showBack = !_showBack);
    if (_showBack) {
      _playVi(widget.dialogue.turns[_index]);
    }
  }

  void _next() {
    final n = widget.dialogue.turns.length;
    if (_index < n - 1) {
      setState(() {
        _index++;
        _showBack = false;
      });
    } else {
      // 끝
      UserStats().recordActivity(isSentence: true);
      Navigator.of(context).pop();
    }
  }

  void _prev() {
    if (_index > 0) {
      setState(() {
        _index--;
        _showBack = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.dialogue;
    final t = d.turns[_index];

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: Text('${d.title} — 문장 외우기',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.notoSans(
                color: AppColors.ink,
                fontWeight: FontWeight.bold,
                fontSize: 14)),
        iconTheme: const IconThemeData(color: AppColors.ink),
        actions: [
          IconButton(
            icon: Icon(
              _showTones ? Icons.show_chart : Icons.show_chart_outlined,
              color: _showTones ? AppConfig.brandColor : AppColors.inkFaint,
              size: 22,
            ),
            tooltip: '성조 곡선 ${_showTones ? "켜짐" : "꺼짐"}',
            onPressed: () => setState(() => _showTones = !_showTones),
          ),
          // 사용자 결정 2026-05-08: 하트 → 단어장(FavoriteWords) 추가
          AnimatedBuilder(
            animation: FavoriteWords(),
            builder: (context, _) {
              final t = widget.dialogue.turns[_index];
              final isFav = FavoriteWords().isFavorite(_itemId(t.turn));
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? AppColors.coral500 : AppColors.inkFaint,
                ),
                tooltip: '단어장 추가',
                onPressed: _toggleFavorite,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: AddressPreferenceService.instance,
          builder: (context, _) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${_index + 1} / ${d.turns.length}',
                          style: GoogleFonts.notoSans(
                              fontSize: 12, color: AppColors.inkFaint)),
                      Text(
                        t.speaker == 'A' ? '내 차례' : '상대 차례',
                        style: GoogleFonts.notoSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: t.speaker == 'A'
                              ? AppConfig.brandColor
                              : AppColors.coral500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: (_index + 1) / d.turns.length,
                      backgroundColor: AppColors.bgDeep,
                      valueColor:
                          AlwaysStoppedAnimation(AppConfig.brandColor),
                      minHeight: 3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 사용자 결정 2026-05-09: 카드 높이 fixed 제거 → 콘텐츠 따라 자동 확장.
                  GestureDetector(
                    onHorizontalDragEnd: (drag) {
                      if (drag.primaryVelocity == null) return;
                      if (drag.primaryVelocity! > 200) {
                        _prev();
                      } else if (drag.primaryVelocity! < -200) {
                        _next();
                      }
                    },
                    child: _showBack
                        ? PolaroidBack(
                            vi: _sub(t.vi),
                            pron: _sub(t.pron),
                            note: t.key,
                            dialect: LanguageService.instance.viRegion.value,
                            showReading: true,
                            showTones: _showTones,
                            // 카드 탭 시 vi TTS 재생 (앞면 전환 X — 사용자 결정 2026-05-09)
                            onTap: () => _playVi(t),
                          )
                        : PolaroidFront(text: _sub(t.ko), onTap: _flip),
                  ),
                  const SizedBox(height: 14),
                  // 사용자 결정 2026-05-08: 4 버튼 (이전/탭하면답/알아요/다음)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _btn(
                        icon: Icons.arrow_back_ios_rounded,
                        label: '이전',
                        color: AppColors.inkFaint,
                        onPressed: _index > 0 ? _prev : null,
                      ),
                      _btn(
                        icon: Icons.touch_app_outlined,
                        label: '탭하면 답',
                        color: AppConfig.brandColor,
                        primary: true,
                        onPressed: _flip,
                      ),
                      _btn(
                        icon: Icons.check_rounded,
                        label: '알아요',
                        color: AppColors.sage500,
                        onPressed: _onKnown,
                      ),
                      _btn(
                        icon: Icons.arrow_forward_ios_rounded,
                        label: _index < d.turns.length - 1 ? '다음' : '완료',
                        color: AppColors.inkFaint,
                        onPressed: _next,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _btn({
    required IconData icon,
    required String label,
    required Color color,
    bool primary = false,
    VoidCallback? onPressed,
  }) {
    final disabled = onPressed == null;
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            // 4 버튼 한 줄 — 컴팩트 사이즈
            width: primary ? 52 : 44,
            height: primary ? 52 : 44,
            decoration: BoxDecoration(
              color: primary ? Colors.white : AppColors.bgSoft,
              shape: BoxShape.circle,
              boxShadow: disabled
                  ? null
                  : [
                      BoxShadow(
                        color: color.withValues(alpha: 0.65),
                        offset: const Offset(0, 3),
                        blurRadius: 0,
                      ),
                      BoxShadow(
                        color: color.withValues(alpha: 0.18),
                        offset: const Offset(0, 6),
                        blurRadius: 10,
                      ),
                    ],
            ),
            alignment: Alignment.center,
            child: Icon(icon,
                color: disabled ? AppColors.inkFaint : color,
                size: primary ? 24 : 20),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.notoSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: disabled ? AppColors.inkFaint : AppColors.inkSoft,
            ),
          ),
        ],
      ),
    );
  }
}
