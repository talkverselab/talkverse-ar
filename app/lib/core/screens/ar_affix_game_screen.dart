import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/ar_affix_patterns.dart';
import '../services/tts_service.dart';
import '../theme/app_colors.dart';

/// AR 문법 메뉴 — 접사게임 초급.
///
/// 5 패턴 (장소 / 도구 / 행위자 / 대상 / 추상명사) 명사 파생.
/// 동사 10 forms 는 advanced 메뉴 (조사와변화) 로 분리.
///
/// 화면 구조:
///   - 상단 sticky banner: "모든 언어에는 불규칙이 있다..."
///   - 5 패턴 카드 (vertical scroll, 색깔 구분)
///   - 각 카드: 패턴 모양 + 예시 3 개 + "퀴즈" 버튼
///   - 퀴즈: 어근 + 패턴 → 단어 맞추기 (객관식)
///   - 전체 RTL
class ArAffixGameScreen extends StatelessWidget {
  const ArAffixGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('🎮 접사 게임 — 명사 파생'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              const _IrregularityBanner(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(14),
                  itemCount: ArAffixPatterns.beginner5.length,
                  itemBuilder: (context, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _PatternCard(
                      pattern: ArAffixPatterns.beginner5[i],
                    ),
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

/// project_irregularity_banner.md — cross-language sticky banner.
class _IrregularityBanner extends StatelessWidget {
  const _IrregularityBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppColors.dangerDark.withValues(alpha: 0.10),
      child: Row(
        children: [
          const Icon(Icons.info_outline,
              size: 16, color: AppColors.dangerDark),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '모든 언어에는 불규칙이 있다. 자주 쓰는 단어일수록 더 많다.',
              style: GoogleFonts.notoSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.dangerDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 패턴 카드 1 개 — 모양 + 예시 3 + 퀴즈 진입.
class _PatternCard extends StatelessWidget {
  final ArAffixPattern pattern;

  const _PatternCard({required this.pattern});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: pattern.color.withValues(alpha: 0.45),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: pattern.color.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 헤더 — 색깔 띠
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: pattern.color.withValues(alpha: 0.12),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Icon(pattern.icon, color: pattern.color),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pattern.nameKo,
                        style: GoogleFonts.notoSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: pattern.color,
                        ),
                      ),
                      Text(
                        pattern.subtitle,
                        style: GoogleFonts.notoSans(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // 패턴 모양 (해라카트 포함)
                Text(
                  pattern.pattern,
                  style: GoogleFonts.notoSansArabic(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: pattern.color,
                  ),
                ),
              ],
            ),
          ),
          // 패턴 로마자
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Text(
              pattern.patternRoman,
              style: GoogleFonts.robotoMono(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          // 예시 3 개
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: pattern.examples
                  .map((ex) => _DerivationRow(derivation: ex))
                  .toList(),
            ),
          ),
          // 퀴즈 버튼
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: pattern.color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(
                  '${pattern.nameKo} 퀴즈 시작',
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => _AffixQuizScreen(pattern: pattern),
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

/// 한 줄 — 어근 (빨강) + 화살표 + 파생 (패턴 색). 탭 → derived word TTS.
class _DerivationRow extends StatelessWidget {
  final ArDerivation derivation;
  static const Color _rootColor = Color(0xFFE53935);

  const _DerivationRow({required this.derivation});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => TtsService.instance
          .speak(derivation.derived, delay: Duration.zero),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            // 어근 (빨강)
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    derivation.rootArabic,
                    style: GoogleFonts.notoSansArabic(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _rootColor,
                    ),
                  ),
                  Text(
                    '${derivation.rootRoman} · ${derivation.rootMeaning}',
                    style: GoogleFonts.notoSans(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // RTL 환경에서 → 화살표 방향. 시각적으로 어근 → 파생 흐름.
            const Icon(Icons.arrow_back_rounded,
                size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            // 파생 단어
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          derivation.derived,
                          style: GoogleFonts.notoSansArabic(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const Icon(Icons.volume_up_rounded,
                          size: 14, color: AppColors.textSecondary),
                    ],
                  ),
                  Text(
                    '${derivation.derivedRoman} · ${derivation.derivedMeaning}',
                    style: GoogleFonts.notoSans(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 퀴즈 화면 — "어근 + 패턴 → 파생 단어" 객관식.
// 첫 버전: 한 패턴의 3 예시를 무작위 순서로 제시. 정답 = 파생 의미. 오답 = 다른 패턴 derivation 의 의미.
// 다음 세션 확장: 점수 기록 / 어근 슬롯 채우기 모드 / TTS 연결.
// =============================================================================

class _AffixQuizScreen extends StatefulWidget {
  final ArAffixPattern pattern;

  const _AffixQuizScreen({required this.pattern});

  @override
  State<_AffixQuizScreen> createState() => _AffixQuizScreenState();
}

class _AffixQuizScreenState extends State<_AffixQuizScreen> {
  late final List<ArDerivation> _questions;
  late final List<ArDerivation> _distractorPool;
  int _idx = 0;
  int _correct = 0;
  String? _selected;
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    _questions = List.of(widget.pattern.examples)..shuffle(Random());
    // distractor = 다른 패턴의 derivation 의미 모음
    _distractorPool = ArAffixPatterns.beginner5
        .where((p) => p.id != widget.pattern.id)
        .expand((p) => p.examples)
        .toList();
  }

  ArDerivation get _q => _questions[_idx];

  List<String> get _choices {
    final correct = _q.derivedMeaning;
    final distractors = (_distractorPool.toList()..shuffle(Random()))
        .take(3)
        .map((d) => d.derivedMeaning)
        .toList();
    final all = [correct, ...distractors]..shuffle(Random());
    return all;
  }

  late List<String> _currentChoices = _choices;

  void _onPick(String choice) {
    if (_revealed) return;
    setState(() {
      _selected = choice;
      _revealed = true;
      if (choice == _q.derivedMeaning) _correct++;
    });
    // 정답·오답 무관하게 정답 단어 발음 (학습 효과)
    TtsService.instance.speak(_q.derived, delay: Duration.zero);
  }

  void _next() {
    if (_idx < _questions.length - 1) {
      setState(() {
        _idx++;
        _selected = null;
        _revealed = false;
        _currentChoices = _choices;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('결과'),
        content: Text(
            '${_questions.length} 문제 중 $_correct 정답!\n\n다음 세션에서 점수 기록·반복 학습 추가 예정.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // dialog
              Navigator.pop(context); // quiz screen
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pattern = widget.pattern;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text('${pattern.nameKo} 퀴즈'),
          centerTitle: true,
          backgroundColor: pattern.color,
          foregroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 진행 표시
                LinearProgressIndicator(
                  value: (_idx + 1) / _questions.length,
                  backgroundColor: pattern.color.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation(pattern.color),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_idx + 1} / ${_questions.length}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSans(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                // 문제 카드
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: pattern.color.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${pattern.nameKo} 패턴 (${pattern.pattern}) 으로\n어근에서 파생된 단어의 뜻은?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.notoSans(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 어근 (빨강)
                      Text(
                        _q.rootArabic,
                        style: GoogleFonts.notoSansArabic(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFE53935),
                        ),
                      ),
                      Text(
                        '${_q.rootRoman} · ${_q.rootMeaning}',
                        style: GoogleFonts.notoSans(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Icon(Icons.arrow_downward_rounded,
                          color: pattern.color, size: 22),
                      const SizedBox(height: 14),
                      // 파생 단어 (패턴 색)
                      Text(
                        _q.derived,
                        style: GoogleFonts.notoSansArabic(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        _q.derivedRoman,
                        style: GoogleFonts.robotoMono(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // 보기 4 개
                ..._currentChoices.map((c) {
                  final isCorrect = c == _q.derivedMeaning;
                  final isPicked = c == _selected;
                  Color bg = Colors.white;
                  Color border = AppColors.textSecondary.withValues(alpha: 0.3);
                  if (_revealed) {
                    if (isCorrect) {
                      bg = AppColors.successDark.withValues(alpha: 0.15);
                      border = AppColors.successDark;
                    } else if (isPicked) {
                      bg = AppColors.dangerDark.withValues(alpha: 0.15);
                      border = AppColors.dangerDark;
                    }
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GestureDetector(
                      onTap: () => _onPick(c),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: border, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                c,
                                style: GoogleFonts.notoSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            if (_revealed && isCorrect)
                              const Icon(Icons.check_circle,
                                  color: AppColors.successDark, size: 22),
                            if (_revealed && isPicked && !isCorrect)
                              const Icon(Icons.cancel,
                                  color: AppColors.dangerDark, size: 22),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const Spacer(),
                if (_revealed)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pattern.color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _next,
                    child: Text(
                      _idx < _questions.length - 1 ? '다음' : '결과 보기',
                      style: GoogleFonts.notoSans(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
