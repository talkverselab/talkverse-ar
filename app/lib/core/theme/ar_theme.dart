import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// 아랍풍 전역 테마 — zh 앱(AppTheme)과 동일한 구조.
/// 앱바 = 녹색 바탕·상아색 글자, 하단 네비 = 먹색 바탕·금색 선택 라벨,
/// 카드 = 상아색 + 금테 + 각진 모서리(기하 문양 감성).
class ArTheme {
  ArTheme._();

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.arGreen,
        onPrimary: AppColors.arIvory,
        primaryContainer: AppColors.arGreenLight,
        onPrimaryContainer: AppColors.arIvory,
        secondary: AppColors.arGold,
        onSecondary: AppColors.arInk,
        secondaryContainer: AppColors.arGoldBright,
        onSecondaryContainer: AppColors.arInk,
        tertiary: AppColors.arTerracotta,
        onTertiary: AppColors.arIvory,
        tertiaryContainer: Color(0xFFF3CFC4),
        onTertiaryContainer: AppColors.arInk,
        error: Color(0xFFB00020),
        onError: Colors.white,
        surface: AppColors.arIvory,
        onSurface: AppColors.arInk,
        surfaceContainerHighest: AppColors.arIvoryDeep,
        onSurfaceVariant: AppColors.arInkLight,
        outline: AppColors.arGoldDeep,
        outlineVariant: Color(0xFFD9C48A),
      ),
      scaffoldBackgroundColor: AppColors.arIvory,
    );

    final textTheme = GoogleFonts.notoSansKrTextTheme(base.textTheme);

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.arGreen,
        foregroundColor: AppColors.arIvory,
        iconTheme: const IconThemeData(color: AppColors.arIvory),
        titleTextStyle: GoogleFonts.notoSansKr(
          color: AppColors.arIvory,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.arIvory,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: AppColors.arGold, width: 0.8),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.arInk,
        indicatorColor: AppColors.arGreen,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.notoSansKr(
            color: selected ? AppColors.arGoldBright : AppColors.arIvoryDeep,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.arIvory : AppColors.arIvoryDeep,
            size: 24,
          );
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.arIvoryDeep,
        labelStyle: const TextStyle(
            color: AppColors.arInk, fontWeight: FontWeight.w600),
        side: const BorderSide(color: AppColors.arGold),
        selectedColor: AppColors.arGreen,
        secondaryLabelStyle: const TextStyle(color: AppColors.arIvory),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.arGold,
        thickness: 0.5,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.arGreen,
        textColor: AppColors.arInk,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.arIvory,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.arGreen,
          foregroundColor: AppColors.arIvory,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.arGreen,
        linearTrackColor: AppColors.arIvoryDeep,
      ),
    );
  }
}

/// 아랍어 표시 전용 폰트 — Naskh 계열(Amiri). 한국어 UI 폰트와 분리.
/// 아랍어는 RTL 이므로 반드시 [Directionality]/`textDirection: TextDirection.rtl`
/// 과 함께 사용.
TextStyle arabicStyle({
  double fontSize = 24,
  FontWeight fontWeight = FontWeight.w700,
  Color color = AppColors.arInk,
  double? height,
}) =>
    GoogleFonts.amiri(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height ?? 1.6,
    );

/// 아랍어 텍스트 위젯 — RTL 방향 + Naskh 폰트를 항상 보장.
class ArabicText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ArabicText(
    this.text, {
    super.key,
    this.fontSize = 24,
    this.fontWeight = FontWeight.w700,
    this.color = AppColors.arInk,
    this.textAlign = TextAlign.right,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textDirection: TextDirection.rtl,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: arabicStyle(
          fontSize: fontSize, fontWeight: fontWeight, color: color),
    );
  }
}
