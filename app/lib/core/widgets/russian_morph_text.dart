import 'dart:convert';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// RU 굴절 색칠 위젯. seed_ru.sql 의 morph_tags jsonb 컬럼을 읽어 token 별 시각화.
///
/// **시각 정책 — 글자색은 항상 검정. 색은 밑줄에만.**
/// 명사·동사·불규칙·발음 모두 *밑줄*만 색칠 → 회화 흐름 유지, 시각 부하 ↓.
///
/// **시각 매핑** (사용자님 Talkverse 굴절 시스템):
/// - **명사** = 검은 글자 + 성 색 실선 밑줄
///   - masc 남성  → #4A90E2 파 밑줄
///   - fem  여성  → #E91E63 핑 밑줄
///   - neut 중성  → #9B9B9B 회 밑줄
/// - **동사 1식/2식** = 검은 글자 + 검은 점선 밑줄
/// - **불규칙** = 검은 글자 + 빨강 점선 밑줄 (#D32F2F)
/// - **발음 갈색** ph (어미만) = -ого/-его·-ей 정자법-발음 차이 → 어미만 갈색 밑줄 (#6D4C41)
/// - **무색** = 인칭 대명사 / 고유명사 / 복수 / 외래어 / 전치사·접속사·부사 / 굳어진 인사·감탄
///
/// **JSON 형식** (per token):
///   {"t": "красивую", "c": "fem"}                 // 검은 글자 + 핑크 밑줄
///   {"t": "лучшего",  "c": "masc", "ph": "его"}  // 본체 파 밑줄, 어미 'его' 갈색 밑줄
///   {"t": "читаю",    "c": "v1"}                  // 검은 점선 밑줄
///   {"t": "идёт",     "c": "irr"}                 // 빨강 점선 밑줄
///   {"t": "Я"}                                    // 무색 (밑줄 X)
///
/// 변화 *원인* 만 밑줄로 시각화. 어미 자체는 라임·반복으로 익히도록 — 격 분리 X.
class RussianMorphText extends StatelessWidget {
  /// items.morph_tags 의 JSON string. NULL/빈 문자열이면 fallback 으로 plain text 렌더.
  final String? morphTagsJson;

  /// fallback 으로 사용할 원문 (morph_tags 없거나 파싱 실패 시).
  final String fallbackText;

  final TextStyle? style;
  final TextAlign textAlign;

  const RussianMorphText({
    super.key,
    required this.morphTagsJson,
    required this.fallbackText,
    this.style,
    this.textAlign = TextAlign.start,
  });

  /// 명사 성 색 (글자색 + 밑줄색 동일).
  static const Color masc = Color(0xFF4A90E2);
  static const Color fem = Color(0xFFE91E63);
  static const Color neut = Color(0xFF9B9B9B);
  /// 불규칙 강조색.
  static const Color irrRed = Color(0xFFD32F2F);
  /// 발음법칙 어미 갈색.
  static const Color phoneticBrown = Color(0xFF6D4C41);
  static const Color defaultBlack = AppColors.textPrimary;

  /// 명사 색 코드 → Color (밑줄·글자색 둘 다).
  static Color? _nounColor(String? key) {
    switch (key) {
      case 'masc':
        return masc;
      case 'fem':
        return fem;
      case 'neut':
        return neut;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final base = (style ?? const TextStyle()).copyWith(
      color: (style?.color) ?? defaultBlack,
    );
    final spans = _buildSpans(base);
    if (spans.isEmpty) {
      return Text(fallbackText, style: base, textAlign: textAlign);
    }
    return RichText(
      text: TextSpan(style: base, children: spans),
      textAlign: textAlign,
    );
  }

  List<InlineSpan> _buildSpans(TextStyle base) {
    if (morphTagsJson == null || morphTagsJson!.isEmpty) {
      return [TextSpan(text: fallbackText)];
    }
    try {
      final raw = jsonDecode(morphTagsJson!);
      if (raw is! List) return [TextSpan(text: fallbackText)];
      final tokens = raw.cast<Map<String, dynamic>>();
      final spans = <InlineSpan>[];
      for (var i = 0; i < tokens.length; i++) {
        if (i > 0) spans.add(const TextSpan(text: ' '));
        spans.addAll(_tokenSpans(tokens[i], base));
      }
      return spans;
    } catch (_) {
      return [TextSpan(text: fallbackText)];
    }
  }

  /// 한 token → 1~2 개 TextSpan.
  /// 명사 = 글자색 + 같은 색 solid 밑줄.
  /// 동사 1식/2식 = 검은 dotted 밑줄, 글자색 X.
  /// 불규칙 = 빨강 글자 + 빨강 dotted 밑줄.
  /// ph 어미 = 토큰 끝 N자만 갈색 split.
  List<InlineSpan> _tokenSpans(Map<String, dynamic> token, TextStyle base) {
    final text = token['t'] as String? ?? '';
    if (text.isEmpty) return const [];
    final colorKey = token['c'] as String?;
    final phSuffix = token['ph'] as String?;

    final bodyStyle = _styleFor(colorKey, base);

    // ph 어미 = 토큰 끝의 N자. 본체는 bodyStyle (성 색 밑줄), 어미는 갈색 밑줄로 override.
    if (phSuffix != null && text.toLowerCase().endsWith(phSuffix.toLowerCase())) {
      final cut = text.length - phSuffix.length;
      final body = text.substring(0, cut);
      final tail = text.substring(cut);
      return [
        if (body.isNotEmpty) TextSpan(text: body, style: bodyStyle),
        TextSpan(
          text: tail,
          style: base.copyWith(
            decoration: TextDecoration.underline,
            decorationColor: phoneticBrown,
            decorationStyle: TextDecorationStyle.solid,
            decorationThickness: 1.6,
          ),
        ),
      ];
    }

    return [TextSpan(text: text, style: bodyStyle)];
  }

  /// 색 코드 → 적용할 스타일. **글자색 항상 검정, 밑줄만 색.**
  TextStyle? _styleFor(String? colorKey, TextStyle base) {
    if (colorKey == null) return null;
    final nounColor = _nounColor(colorKey);
    if (nounColor != null) {
      // 명사 = 검정 글자 + 성 색 실선 밑줄
      return base.copyWith(
        decoration: TextDecoration.underline,
        decorationColor: nounColor,
        decorationStyle: TextDecorationStyle.solid,
        decorationThickness: 1.6,
      );
    }
    if (colorKey == 'v1' || colorKey == 'v2') {
      // 동사 1식/2식 = 검정 글자 + 검은 점선 밑줄
      return base.copyWith(
        decoration: TextDecoration.underline,
        decorationColor: defaultBlack,
        decorationStyle: TextDecorationStyle.dotted,
        decorationThickness: 1.6,
      );
    }
    if (colorKey == 'irr') {
      // 불규칙 = 검정 글자 + 빨강 점선 밑줄
      return base.copyWith(
        decoration: TextDecoration.underline,
        decorationColor: irrRed,
        decorationStyle: TextDecorationStyle.dotted,
        decorationThickness: 1.6,
      );
    }
    return null;
  }
}
