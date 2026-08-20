import 'package:characters/characters.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_config.dart';
import '../models/word.dart';
import '../services/language_service.dart';
import '../theme/app_colors.dart';

Map<String, Color> get caseColors => AppConfig.grammarTagColors;
Map<String, Color> get genderColors => AppConfig.genderTagColors;

const Color newWordBg = AppColors.newHighlight;

/// MY (미얀마어) Pali only 글자 — 회색 톤다운 + 학습 제외 안내.
/// 자음 7개 (ta1_pali 그룹 + ဈ ဠ) + 독립 모음 6개 (ဦ 제외).
const _myPaliChars = <String>{
  // Pali only consonants
  'ဈ', 'ဋ', 'ဌ', 'ဍ', 'ဎ', 'ဏ', 'ဠ',
  // Pali only independent vowels (ဦ 는 ဦး "분" 등 일상 사용 → 제외)
  'ဣ', 'ဤ', 'ဥ', 'ဧ', 'ဩ', 'ဪ',
};

const Color _paliColor = Color(0xFF9E9E9E);

/// 글자가 Pali 전용이면 회색 반환, 아니면 null.
/// 현재 MY 언어에서만 활성. 다른 언어는 무조건 null.
Color? _paliColorFor(String char) {
  if (LanguageService.instance.code.value != 'my') return null;
  return _myPaliChars.contains(char) ? _paliColor : null;
}

class MarkedText extends StatelessWidget {
  final List<TextSegment> segments;
  final double fontSize;
  final FontWeight fontWeight;
  final Color defaultColor;
  final bool applyNewHighlight;
  final void Function(TextSegment segment)? onSegmentTap;

  const MarkedText({
    super.key,
    required this.segments,
    this.fontSize = 20,
    this.fontWeight = FontWeight.normal,
    this.defaultColor = AppColors.textPrimary,
    this.applyNewHighlight = true,
    this.onSegmentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: segments.map((seg) {
        // 디자인 정책 (사용자 요청 2026-04-21):
        //   * 마커는 색·bold 변경 없이 검정 텍스트 유지
        //   * 표시 = 검정 밑줄만
        //   * 명사 성(gender) = 단일 실선
        //   * 격(case)        = 점선 (구분만)
        //   * 우선순위: case > gender (둘 다 있으면 점선)
        //   * 탭 → 어떤 마커인지 SnackBar/툴팁 (호출부에서 처리)
        final hasGender = seg.genderTag != null;
        final hasCase = seg.caseTag != null;
        final showNew = applyNewHighlight && seg.isNew;

        TextDecoration? deco;
        TextDecorationStyle? decoStyle;
        if (hasCase) {
          deco = TextDecoration.underline;
          decoStyle = TextDecorationStyle.dashed;
        } else if (hasGender) {
          deco = TextDecoration.underline;
          decoStyle = TextDecorationStyle.solid;
        }

        // Pali 회색 처리: MY 언어 + Pali 전용 글자 인 경우 글자 단위 색 분리.
        // 다른 언어 또는 Pali 글자 없으면 단일 Text 위젯 그대로.
        final hasPali = LanguageService.instance.code.value == 'my' &&
            seg.text.characters.any((c) => _myPaliChars.contains(c));
        final baseStyle = TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: defaultColor,
          decoration: deco,
          decorationColor: defaultColor,
          decorationStyle: decoStyle,
          decorationThickness: 1.6,
        );
        final Widget textWidget = hasPali
            ? Text.rich(
                TextSpan(
                  children: seg.text.characters.map((c) {
                    final paliColor = _paliColorFor(c);
                    return TextSpan(
                      text: c,
                      style: paliColor != null
                          ? baseStyle.copyWith(color: paliColor)
                          : baseStyle,
                    );
                  }).toList(),
                ),
              )
            : Text(seg.text, style: baseStyle);
        final content = showNew
            ? Container(
                decoration: const BoxDecoration(
                  color: newWordBg,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: textWidget,
              )
            : textWidget;
        if (onSegmentTap != null && seg.hasHighlight) {
          return GestureDetector(
            onTap: () => onSegmentTap!(seg),
            child: content,
          );
        }
        return content;
      }).toList(),
    );
  }
}

class CaseLegend extends StatelessWidget {
  const CaseLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          ...caseColors.entries.map((e) => _chip(
                AppConfig.grammarTagNames[e.key]!,
                e.value,
              )),
          _newChip(),
        ],
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 6, top: 4, bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color),
      ),
      child: Center(
        child: Text(label,
            style: GoogleFonts.notoSans(color: color, fontSize: 12)),
      ),
    );
  }

  Widget _newChip() {
    return Container(
      margin: const EdgeInsets.only(right: 6, top: 4, bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: newWordBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text('새 단어',
            style: GoogleFonts.notoSans(
                color: Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
