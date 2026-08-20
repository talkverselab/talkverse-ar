import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/user_stats.dart';
import '../theme/app_colors.dart';

/// 이번 주 7일 활동 strip — 요일 박스(월~일) × 7.
///
/// 신디자인 (Variant B 채택):
/// - 완료 = sage 그린 + ✓
/// - 오늘(미완) = peach + 🔥
/// - 미래/잠금 = nm-inset (눌린 회색)
class WeeklyStrip extends StatelessWidget {
  const WeeklyStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = UserStats();
    final last7 = stats.last7Days(); // [{date, count}] × 7, oldest → today
    final goal = stats.dailyGoal;
    final today = DateTime.now();

    // 요일 라벨 (오늘 기준 7일 전 → 오늘)
    String weekdayKo(DateTime d) {
      const ko = ['월', '화', '수', '목', '금', '토', '일'];
      return ko[d.weekday - 1];
    }

    final completed = last7.where((d) => d.count >= goal).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('이번 주',
                style: GoogleFonts.notoSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink)),
            Text('$completed / 7 완료',
                style: GoogleFonts.notoSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.inkFaint)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(7, (i) {
            final d = last7[i];
            final isToday = d.date.year == today.year &&
                d.date.month == today.month &&
                d.date.day == today.day;
            final reached = d.count >= goal;
            final isPast = d.date.isBefore(DateTime(today.year, today.month, today.day));

            // 상태 결정
            final Color bg;
            final Color fg;
            final List<BoxShadow>? shadow;
            final Widget icon;

            if (reached) {
              bg = AppColors.sage200;
              fg = AppColors.sage700;
              shadow = [
                BoxShadow(
                  color: AppColors.sage400,
                  offset: const Offset(0, 3),
                  blurRadius: 0,
                ),
                BoxShadow(
                  color: AppColors.sage400.withValues(alpha: 0.25),
                  offset: const Offset(0, 5),
                  blurRadius: 8,
                ),
              ];
              icon = Icon(Icons.check_rounded, size: 20, color: fg);
            } else if (isToday) {
              bg = AppColors.peach300;
              fg = AppColors.peach600;
              shadow = [
                BoxShadow(
                  color: AppColors.peach400,
                  offset: const Offset(0, 3),
                  blurRadius: 0,
                ),
                BoxShadow(
                  color: AppColors.peach400.withValues(alpha: 0.3),
                  offset: const Offset(0, 5),
                  blurRadius: 10,
                ),
              ];
              // 사용자 결정 2026-05-07: V 체크 일관 — 오늘 미완은 outlined check.
              icon = Icon(Icons.check_rounded,
                  size: 18, color: fg.withValues(alpha: 0.55));
            } else {
              // 과거(미완) 또는 미래(잠금)
              bg = AppColors.bg;
              fg = AppColors.inkFaint;
              shadow = null;
              icon = Icon(
                isPast ? Icons.remove_rounded : Icons.lock_outline_rounded,
                size: 14,
                color: AppColors.inkFaint,
              );
            }

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: i == 0 ? 0 : 4, right: i == 6 ? 0 : 4),
                child: Container(
                  height: 64,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: shadow,
                    border: shadow == null
                        ? Border.all(color: AppColors.bgDeep, width: 1)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        weekdayKo(d.date),
                        style: GoogleFonts.notoSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: fg.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 2),
                      icon,
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
