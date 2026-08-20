import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_config.dart';
import '../data/user_stats.dart';
import '../data/word_data.dart';
import '../models/word.dart';
import '../services/tts_service.dart';
import '../theme/app_colors.dart';
import '../config/language_registry.dart';
import '../theme/ar_theme.dart';
import '../widgets/arabic_keyboard_guide.dart';

/// Typing practice using the **system keyboard** (Gboard / Samsung / iOS).
/// 아랍어 IME 가 필요 — 도움말 아이콘에서 설치 안내. 아랍어는 RTL 이므로
/// 목표 텍스트와 입력 필드 모두 `TextDirection.rtl` 로 렌더링한다.
class KeyboardScreen extends StatefulWidget {
  final int? course;
  /// 'word' | 'sentence' | null(혼합). 메뉴 단계에서 분리해 받음.
  final ItemType? itemType;
  /// 부록(appendix) 언어 override — 예: 'lo'. null 이면 현재 주 언어.
  /// keyboardPool 은 주+부록을 모두 담으므로 ID prefix 로 한정.
  final String? languageOverride;
  const KeyboardScreen({
    super.key,
    this.course,
    this.itemType,
    this.languageOverride,
  });

  @override
  State<KeyboardScreen> createState() => _KeyboardScreenState();
}

class _KeyboardScreenState extends State<KeyboardScreen> {
  late final List<Word> practiceWords;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  int currentWordIndex = 0;
  bool? isCorrect;
  int score = 0;

  @override
  void initState() {
    super.initState();
    final all = keyboardPool();
    final langPrefix = widget.languageOverride;
    practiceWords = all.where((w) {
      if (widget.course != null && w.course != widget.course) return false;
      if (widget.itemType != null && w.type != widget.itemType) return false;
      if (langPrefix != null && !w.id.startsWith('$langPrefix:')) return false;
      return true;
    }).toList();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 부록 언어 override 시 TTS locale 도 일시 전환.
      await TtsService.instance.setLanguageOverride(widget.languageOverride);
      _speakCurrent();
      if (practiceWords.isNotEmpty) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    TtsService.instance.stop();
    // 부록 → 주 언어 locale 로 복귀 (다른 화면 영향 없도록).
    if (widget.languageOverride != null) {
      TtsService.instance.setLanguageOverride(null);
    }
    super.dispose();
  }

  void _speakCurrent() {
    if (practiceWords.isEmpty) return;
    TtsService.instance.speak(targetChars);
  }

  Word get current => practiceWords[currentWordIndex];

  /// Target-language characters with markers stripped — what the user types.
  /// v17: vi 호칭 placeholder 치환 적용된 텍스트로 연습.
  String get targetChars => current.targetPlainForCurrent;
  String get pinyin => current.romanizationForCurrent;
  String get meaning => current.korean;

  /// 아랍어 타슈킬(모음 부호 U+064B~U+0652, U+0670)·타트윌(U+0640) 제거 +
  /// 알리프 변형(أ إ آ → ا) 통일. 사용자는 기본 자음만 쳐도 정답 처리.
  static String _normalizeArabic(String s) => s
      .replaceAll(RegExp('[ً-ْٰـ]'), '')
      .replaceAll(RegExp('[أإآ]'), 'ا')
      .replaceAll('ى', 'ي') // ى → ي
      .replaceAll('ة', 'ه'); // ة → ه

  void _onChanged(String value) {
    final trimmed = _normalizeArabic(value.trim());
    final target = _normalizeArabic(targetChars);
    if (trimmed.isEmpty) {
      if (isCorrect != null) setState(() => isCorrect = null);
      return;
    }
    if (trimmed.length < target.length) {
      if (isCorrect != null) setState(() => isCorrect = null);
      return;
    }
    final correct = trimmed == target;
    setState(() => isCorrect = correct);
    if (correct) {
      score++;
      UserStats().recordActivity();
      _focusNode.unfocus();
    }
  }

  void nextWord() {
    setState(() {
      currentWordIndex = (currentWordIndex + 1) % practiceWords.length;
      _controller.clear();
      isCorrect = null;
    });
    _speakCurrent();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    if (practiceWords.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: Text('⌨️ 키보드 연습',
              style: GoogleFonts.notoSans(
                  color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        ),
        body: const Center(
          child: Text('연습할 단어 없음',
              style: TextStyle(color: AppColors.textSecondary)),
        ),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
            widget.course == null
                ? '⌨️ 키보드 연습'
                : '⌨️ ${AppConfig.courseDisplayName(widget.course!)}',
            style: GoogleFonts.notoSans(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: '키보드 설정법',
            onPressed: () => showArabicKeyboardGuide(context),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text('점수: $score',
                  style: GoogleFonts.notoSans(
                      color: AppColors.successDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      // Content scrolls when the soft keyboard cuts into the viewport so
      // the ElevatedButton never "bottom overflowed by N pixels".
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _TargetCard(
                targetChars: targetChars,
                pinyin: pinyin,
                meaning: meaning,
                onSpeak: _speakCurrent,
              ),
              const SizedBox(height: 16),
              _InputField(
                controller: _controller,
                focusNode: _focusNode,
                isCorrect: isCorrect,
                onChanged: _onChanged,
                onSubmitted: (_) => _onChanged(_controller.text),
              ),
              const SizedBox(height: 12),
              _KeyboardHint(onTap: () => showArabicKeyboardGuide(context)),
              if (isCorrect != null) ...[
                const SizedBox(height: 12),
                Text(
                  isCorrect! ? '🎉 정답!' : '❌ 다시 시도해보세요',
                  style: GoogleFonts.notoSans(
                    color: isCorrect!
                        ? AppColors.successDark
                        : AppColors.dangerDark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: nextWord,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(
                    isCorrect == true ? '다음 단어 →' : '건너뛰기',
                    style: GoogleFonts.notoSans(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TargetCard extends StatelessWidget {
  final String targetChars;
  final String pinyin;
  final String meaning;
  final VoidCallback onSpeak;

  const _TargetCard({
    required this.targetChars,
    required this.pinyin,
    required this.meaning,
    required this.onSpeak,
  });

  static bool get _rtl => LanguageRegistry.current.isRtl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppConfig.brandColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppConfig.brandColor.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(targetChars,
                    textAlign: TextAlign.center,
                    textDirection: _rtl
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    style: _rtl
                        ? arabicStyle(
                            fontSize: 44,
                            color: Colors.white,
                            height: 1.5)
                        : const TextStyle(
                            fontSize: 42,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onSpeak,
                icon: const Icon(Icons.volume_up),
                color: Colors.white,
                tooltip: '발음 듣기',
              ),
            ],
          ),
          if (pinyin.isNotEmpty)
            Text(pinyin,
                style: GoogleFonts.notoSans(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontSize: 16,
                    fontStyle: FontStyle.italic)),
          const SizedBox(height: 4),
          Text(meaning,
              style: GoogleFonts.notoSans(
                  color: Colors.white.withValues(alpha: 0.9), fontSize: 16)),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool? isCorrect;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  const _InputField({
    required this.controller,
    required this.focusNode,
    required this.isCorrect,
    required this.onChanged,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isCorrect == true
        ? AppColors.success
        : isCorrect == false
            ? AppColors.danger
            : AppColors.cardBorder;
    final fillColor = isCorrect == true
        ? AppColors.success.withValues(alpha: 0.08)
        : isCorrect == false
            ? AppColors.danger.withValues(alpha: 0.08)
            : AppColors.surface;
    final rtl = LanguageRegistry.current.isRtl;
    final inkColor = isCorrect == true
        ? AppColors.successDark
        : isCorrect == false
            ? AppColors.dangerDark
            : AppColors.textPrimary;
    return TextField(
      controller: controller,
      focusNode: focusNode,
      textAlign: TextAlign.center,
      // 아랍어: 오른쪽→왼쪽 입력. 커서가 오른쪽에서 시작.
      textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
      autocorrect: false,
      enableSuggestions: false,
      style: rtl
          ? arabicStyle(fontSize: 34, color: inkColor, height: 1.5)
          : TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: inkColor,
            ),
      decoration: InputDecoration(
        hintText: rtl ? 'اكتب هنا' : '입력',
        hintStyle: const TextStyle(
            color: AppColors.textMuted, fontSize: 18, fontWeight: FontWeight.w400),
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.backspace_outlined,
                    color: AppColors.textSecondary),
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
              ),
      ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}

class _KeyboardHint extends StatelessWidget {
  final VoidCallback onTap;
  const _KeyboardHint({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline,
                size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              '키보드가 없으면? 설정 방법 보기',
              style: GoogleFonts.notoSans(
                fontSize: 13,
                color: AppColors.textSecondary,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
