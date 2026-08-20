import 'package:flutter/material.dart';

/// 한글 독음의 강세 음절을 시각화하는 위젯.
///
/// 입력 포맷: `*음절*` 로 감싼 부분이 강세로 표시됨.
///   "스빠*시*바"   → 스빠 + 시(볼드+밑줄) + 바
///   "빠*좔*루스따" → 빠 + 좔(강조) + 루스따
///
/// 비강세 러시아어 모음(о→아 등)을 한글 독음이 이미 반영하므로,
/// 강세 위치 하나만 표시하면 학습자가 발음을 정확히 짚을 수 있음.
///
/// 마커가 없으면 평범한 Text 와 동일하게 렌더.
class StressedRomanization extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  const StressedRomanization(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final base = style ?? DefaultTextStyle.of(context).style;
    if (!text.contains('*')) {
      return Text(text, style: base, textAlign: textAlign);
    }
    final parts = text.split('*');
    final spans = <TextSpan>[];
    for (var i = 0; i < parts.length; i++) {
      if (parts[i].isEmpty) continue;
      final isStress = i.isOdd;
      spans.add(TextSpan(
        text: parts[i],
        style: isStress
            ? base.copyWith(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationThickness: 2,
              )
            : null,
      ));
    }
    return RichText(
      text: TextSpan(style: base, children: spans),
      textAlign: textAlign ?? TextAlign.start,
    );
  }
}
