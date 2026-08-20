import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/app_config.dart';
import '../theme/app_colors.dart';
import 'talky_mascot.dart';

/// 홈 상단 큰 Hero 카드 — 오늘의 수업/주요 액션 진입점.
///
/// **신디자인 (2026-05, 회화 연습 카드와 톤 통일)**:
/// - cream `bgSoft` 배경
/// - brand 컬러 그림자 (offset 0/4 blur 0 + 0/8 blur 14) — Pastel Neumorphism lip
/// - 텍스트 brand color, 라벨은 textSecondary
/// - 좌: 라벨 + 큰 타이틀, 우: CTA pill + Talky
class HeroCard extends StatelessWidget {
  final String label; // 예: "오늘의 목표"
  final String title; // 예: "문장 20개"
  /// emoji 직접 지정 — null이면 daysInactive 기반 Talky 표정.
  final String? emoji;
  /// Talky 표정 단계 산출용 (0=오늘 학습, 6+=체념).
  /// emoji가 지정되면 무시됨.
  final int daysInactive;
  final String ctaLabel; // 예: "시작하기"
  final VoidCallback? onTap;

  const HeroCard({
    super.key,
    required this.label,
    required this.title,
    this.emoji,
    this.daysInactive = 0,
    this.ctaLabel = '시작하기',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final brand = AppConfig.brandColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          // 회화 연습 카드와 동일 — bgSoft cream + brand 컬러 그림자
          color: AppColors.bgSoft,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: brand.withValues(alpha: 0.85),
              offset: const Offset(0, 4),
              blurRadius: 0,
            ),
            BoxShadow(
              color: brand.withValues(alpha: 0.22),
              offset: const Offset(0, 8),
              blurRadius: 14,
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(18, 14, 14, 16),
        child: Row(
          children: [
            // 좌측: 라벨 + 타이틀
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: GoogleFonts.notoSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: GoogleFonts.notoSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // CTA pill — brand 컬러 + 흰 텍스트
            Container(
              padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
              decoration: BoxDecoration(
                color: brand,
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: brand.withValues(alpha: 0.4),
                    offset: const Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.play_arrow_rounded,
                        size: 14, color: brand),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    ctaLabel,
                    style: GoogleFonts.notoSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // 우측: 마스코트
            emoji != null && emoji!.isNotEmpty
                ? Text(
                    emoji!,
                    style: const TextStyle(fontSize: 40, height: 1.0),
                  )
                : TalkyMascot(daysInactive: daysInactive, size: 44),
          ],
        ),
      ),
    );
  }
}
