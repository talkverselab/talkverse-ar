import 'dart:convert';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// MN 굴절 색칠 위젯 — UniMorph khk 의 morph_tags jsonb 컬럼 기반.
///
/// **시각 정책 — 글자색 항상 검정. 색은 밑줄에만** (RU 패턴 재활용).
/// 회화 흐름 유지, 시각 부하 ↓.
///
/// **시각 매핑** (몽골어 7격 + 모음조화):
/// - **명사 격 변화** = 검은 글자 + 격 색 실선 밑줄
///   - nom 주격  → (밑줄 X — 기본형)
///   - gen 속격  → #D32F2F 빨강 (-ийн / -ын)
///   - dat 여격  → #388E3C 초록 (-д / -т)
///   - acc 대격  → #7B1FA2 보라 (-ийг / -ыг)
///   - abl 탈격  → #F57C00 주황 (-аас / -ээс)
///   - inst 도구격  → #00838F 청록 (-аар / -ээр)
///   - com 공동격  → #E91E63 핑크 (-тай / -тэй)
///   - voc 호격·재귀  → #6D4C41 갈색 (-аа / -ээ)
/// - **동사 어미** = 검은 글자 + 검은 점선 밑줄 (-ж байна / -сан / -на 등)
/// - **모음조화** (gh = vowel harmony):
///   - back  후설 (양성)  → #EF6C00 따뜻한 주황 점선 밑줄
///   - front 전설 (음성)  → #1976D2 차가운 파랑 점선 밑줄
///   - neut  중성 (и)      → 무색 (점선 X)
/// - **무색** = 인칭 대명사 / 고유명사 / 외래어 / 어조사·감탄·접속사
///
/// **JSON 형식** (per token):
///   {"t": "номын",     "c": "gen"}            // 검은 글자 + 빨강 밑줄 (속격)
///   {"t": "номд",      "c": "dat"}            // 초록 밑줄
///   {"t": "хайртай",   "c": "com"}            // 핑크 밑줄 (공동격)
///   {"t": "удаан",     "gh": "back"}          // 후설 모음조화 주황 점선
///   {"t": "ирсэн",     "c": "verb"}           // 동사 어미 점선
///   {"t": "Жон"}                              // 무색 (고유명사)
class MongolianMorphText extends StatelessWidget {
  /// items.morph_tags 의 JSON string. NULL/빈 문자열이면 fallback plain text.
  final String? morphTagsJson;

  /// fallback 으로 사용할 원문 (morph_tags 없거나 파싱 실패 시).
  final String fallbackText;

  final TextStyle? style;
  final TextAlign textAlign;

  const MongolianMorphText({
    super.key,
    required this.morphTagsJson,
    required this.fallbackText,
    this.style,
    this.textAlign = TextAlign.start,
  });

  /// 격 색상 (밑줄 색).
  static const Color gen = Color(0xFFD32F2F);
  static const Color dat = Color(0xFF388E3C);
  static const Color acc = Color(0xFF7B1FA2);
  static const Color abl = Color(0xFFF57C00);
  static const Color inst = Color(0xFF00838F);
  static const Color com = Color(0xFFE91E63);
  static const Color voc = Color(0xFF6D4C41);

  /// 모음조화 색상 (점선 밑줄).
  static const Color vhBack = Color(0xFFEF6C00); // 후설 (양성)
  static const Color vhFront = Color(0xFF1976D2); // 전설 (음성)

  static const Color defaultBlack = AppColors.textPrimary;

  /// 격 코드 → Color (밑줄 색).
  static Color? _caseColor(String? key) {
    switch (key) {
      case 'gen':
        return gen;
      case 'dat':
        return dat;
      case 'acc':
        return acc;
      case 'abl':
        return abl;
      case 'inst':
        return inst;
      case 'com':
        return com;
      case 'voc':
        return voc;
      default:
        return null;
    }
  }

  /// 모음조화 코드 → Color (점선 밑줄 색).
  static Color? _vhColor(String? key) {
    switch (key) {
      case 'back':
        return vhBack;
      case 'front':
        return vhFront;
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
        spans.add(_tokenSpan(tokens[i], base));
      }
      return spans;
    } catch (_) {
      return [TextSpan(text: fallbackText)];
    }
  }

  /// 한 token → 1 TextSpan.
  /// c (격) 우선 → gh (모음조화) → 'verb' (어미 점선) → 무색.
  TextSpan _tokenSpan(Map<String, dynamic> token, TextStyle base) {
    final text = token['t'] as String? ?? '';
    if (text.isEmpty) return const TextSpan(text: '');
    final caseKey = token['c'] as String?;
    final vhKey = token['gh'] as String?;

    final style = _styleFor(caseKey, vhKey, base);
    return TextSpan(text: text, style: style);
  }

  /// 색 코드 → 적용할 스타일. **글자색 항상 검정, 밑줄만 색.**
  TextStyle? _styleFor(String? caseKey, String? vhKey, TextStyle base) {
    // 1. 격 (case) — 우선 (가장 중요한 학습 시각화)
    final caseColor = _caseColor(caseKey);
    if (caseColor != null) {
      return base.copyWith(
        decoration: TextDecoration.underline,
        decorationColor: caseColor,
        decorationStyle: TextDecorationStyle.solid,
        decorationThickness: 1.6,
      );
    }
    // 2. 동사 어미 표시 (검은 점선)
    if (caseKey == 'verb' || caseKey == 'v') {
      return base.copyWith(
        decoration: TextDecoration.underline,
        decorationColor: defaultBlack,
        decorationStyle: TextDecorationStyle.dotted,
        decorationThickness: 1.6,
      );
    }
    // 3. 모음조화 (gh) — 격이 없을 때만 적용
    final vhColor = _vhColor(vhKey);
    if (vhColor != null) {
      return base.copyWith(
        decoration: TextDecoration.underline,
        decorationColor: vhColor,
        decorationStyle: TextDecorationStyle.dotted,
        decorationThickness: 1.6,
      );
    }
    return null;
  }
}
