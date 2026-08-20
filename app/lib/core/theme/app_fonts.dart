import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized font system for Talkverse.
///
/// Global standard:
///   * Body / UI / dialogs           → Noto Sans CJK SC (= Source Han Sans SC,
///     OFL 1.1, 글로벌 표준 CJK 산세리프). Latin glyphs included so this single
///     family covers UI text in all languages we ship.
///   * Hanzi learning cards (large)  → Ma Shan Zheng (Google Fonts). 楷体(Kaiti)
///     계열 손글씨 스타일로 획순·필체 학습에 최적. Free, OFL.
///
/// Usage:
///   ```dart
///   // 1) Apply globally in MaterialApp.theme:
///   theme: AppFonts.applyGlobalTheme(ThemeData(...))
///
///   // 2) For Hanzi flash-card text:
///   Text('我', style: AppFonts.hanziCard(fontSize: 96))
///
///   // 3) For ad-hoc body styling:
///   Text('你好', style: AppFonts.body(fontSize: 16))
///   ```
class AppFonts {
  AppFonts._();

  /// Global UI / body text style — Noto Sans CJK SC.
  /// Covers Latin + Simplified Chinese + many other CJK glyphs.
  static TextStyle body({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.notoSansSc(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
    );
  }

  /// Hanzi card style — Noto Sans SC (사용자 요청에 따라 sans-serif 통일).
  /// Use for large 한자 학습 cards (60pt+).
  /// 손글씨 스타일이 필요하면 hanziKaiti() 별도 사용.
  static TextStyle hanziCard({
    double fontSize = 96,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) {
    return GoogleFonts.notoSansSc(
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color,
      height: height,
    );
  }

  /// Optional 손글씨 스타일 (MaShanZheng) — 필요할 때만.
  static TextStyle hanziKaiti({
    double fontSize = 96,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) {
    return GoogleFonts.maShanZheng(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  /// Apply Noto Sans CJK SC globally to a ThemeData's textTheme.
  /// Call this when constructing your MaterialApp theme.
  static ThemeData applyGlobalTheme(ThemeData base) {
    return base.copyWith(
      textTheme: GoogleFonts.notoSansScTextTheme(base.textTheme),
      primaryTextTheme:
          GoogleFonts.notoSansScTextTheme(base.primaryTextTheme),
    );
  }
}
