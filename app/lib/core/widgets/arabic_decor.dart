import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/ar_theme.dart';

/// 인장(ختم) — zh SealStamp 의 아랍 버전. 녹색 사각 타일 위에 아랍 글자 1~4자.
/// 아랍어는 RTL 이므로 글자 방향을 항상 rtl 로 고정한다.
class ArabicSeal extends StatelessWidget {
  final String text;
  final double size;
  final Color? color;

  const ArabicSeal({
    super.key,
    required this.text,
    this.size = 56,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.arGreen;
    final isOne = text.runes.length == 1;
    final fontSize = isOne ? size * 0.62 : size * 0.34;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: c,
        borderRadius: BorderRadius.circular(2),
        border:
            Border.all(color: AppColors.arGold, width: size > 30 ? 1.5 : 1),
        boxShadow: [
          BoxShadow(
            color: c.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            text,
            textDirection: TextDirection.rtl,
            style: arabicStyle(
              fontSize: fontSize,
              color: AppColors.arIvory,
              height: 1.15,
            ),
          ),
        ),
      ),
    );
  }
}

/// 기하 문양 배경 — 8각 별(نجمة ثمانية) 격자. 장식용 (opacity 낮게).
class GeometricPattern extends StatelessWidget {
  final Color color;
  final double opacity;

  const GeometricPattern({
    super.key,
    this.color = AppColors.arGold,
    this.opacity = 0.08,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _StarLatticePainter(color: color.withValues(alpha: opacity)),
      child: const SizedBox.expand(),
    );
  }
}

class _StarLatticePainter extends CustomPainter {
  final Color color;
  _StarLatticePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    const step = 64.0;
    for (var x = 0.0; x < size.width + step; x += step) {
      for (var y = 0.0; y < size.height + step; y += step) {
        _drawStar8(canvas, paint, Offset(x, y), 20);
      }
    }
  }

  /// 정사각형 두 개를 45° 겹친 8각 별.
  void _drawStar8(Canvas canvas, Paint paint, Offset c, double r) {
    for (final rot in [0.0, math.pi / 4]) {
      final path = Path();
      for (var i = 0; i < 4; i++) {
        final a = rot + i * math.pi / 2;
        final p = Offset(c.dx + r * math.cos(a), c.dy + r * math.sin(a));
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

/// 아치 띠 — 모스크 아케이드(말굽 아치) 연속 패턴 디바이더.
class ArchDivider extends StatelessWidget {
  final double height;
  final Color color;
  const ArchDivider(
      {super.key, this.height = 14, this.color = AppColors.arGold});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _ArchPainter(color: color)),
    );
  }
}

class _ArchPainter extends CustomPainter {
  final Color color;
  _ArchPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final w = size.height * 1.4;
    for (var x = 0.0; x < size.width; x += w) {
      final path = Path()
        ..moveTo(x, size.height)
        ..lineTo(x, size.height * 0.55)
        ..arcToPoint(
          Offset(x + w, size.height * 0.55),
          radius: Radius.circular(w * 0.55),
        )
        ..lineTo(x + w, size.height);
      canvas.drawPath(path, paint);
    }
    canvas.drawLine(Offset(0, size.height - 0.6),
        Offset(size.width, size.height - 0.6), paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

/// 갈대펜(قلم) 분리선 — 금색 그라데이션 라인 + 가운데 마름모.
class CalligraphyDivider extends StatelessWidget {
  final Color color;
  const CalligraphyDivider({super.key, this.color = AppColors.arGoldDeep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _line(true)),
        Transform.rotate(
          angle: math.pi / 4,
          child: Container(width: 7, height: 7, color: color),
        ),
        Expanded(child: _line(false)),
      ],
    );
  }

  Widget _line(bool fadeStart) => Container(
        height: 2,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: fadeStart
                ? [color.withValues(alpha: 0), color]
                : [color, color.withValues(alpha: 0)],
          ),
        ),
      );
}

/// 아랍풍 카드 — 녹색 헤더 + 금테 + 각진 모서리.
class ArabicCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final String? sealText;
  final VoidCallback? onTap;
  final Color? accent;
  final EdgeInsetsGeometry padding;

  const ArabicCard({
    super.key,
    required this.child,
    this.title,
    this.sealText,
    this.onTap,
    this.accent,
    this.padding = const EdgeInsets.all(14),
  });

  @override
  Widget build(BuildContext context) {
    final a = accent ?? AppColors.arGreen;
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.arIvory,
          border: Border.all(color: AppColors.arGold.withValues(alpha: 0.7)),
          boxShadow: [
            BoxShadow(
              color: AppColors.arInk.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null)
              Container(
                color: a,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  children: [
                    if (sealText != null) ...[
                      ArabicSeal(
                          text: sealText!,
                          size: 22,
                          color: AppColors.arGreenDeep),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Text(
                        title!,
                        style: const TextStyle(
                          color: AppColors.arIvory,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    if (onTap != null)
                      const Icon(Icons.chevron_right,
                          color: AppColors.arIvory, size: 18),
                  ],
                ),
              ),
            Padding(padding: padding, child: child),
          ],
        ),
      ),
    );
  }
}

/// 오늘의 학습 카드 — 녹색 그라데이션 + 사막·모스크 실루엣 + 진행바.
class TodayMissionCard extends StatelessWidget {
  final String level;
  final String lessonTitle;
  final String lessonSubtitle;
  final String arabicWord;
  final int progress;
  final int total;
  final VoidCallback? onTap;

  const TodayMissionCard({
    super.key,
    required this.level,
    required this.lessonTitle,
    required this.lessonSubtitle,
    required this.progress,
    required this.total,
    this.arabicWord = 'اليوم',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.arGreenDeep, AppColors.arGreen],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: AppColors.arGold, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.arGreen.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              bottom: 0,
              child: CustomPaint(
                size: const Size(170, 100),
                painter: _SkylinePainter(),
              ),
            ),
            // 아랍어 장식 단어 (오른쪽 상단 — RTL 감성)
            Positioned(
              right: 14,
              top: 10,
              child: Text(
                arabicWord,
                textDirection: TextDirection.rtl,
                style: arabicStyle(
                  fontSize: 26,
                  color: AppColors.arGoldBright.withValues(alpha: 0.9),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.arGoldBright,
                      border:
                          Border.all(color: AppColors.arGoldDeep, width: 0.6),
                    ),
                    child: Text(
                      level,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.arInk,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    lessonTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.arIvory,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lessonSubtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.arIvory.withValues(alpha: 0.85),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '$progress / $total',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.arGoldBright,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Stack(
                    children: [
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.arIvory.withValues(alpha: 0.25),
                          border:
                              Border.all(color: AppColors.arGold, width: 0.6),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: total > 0
                            ? (progress / total).clamp(0.0, 1.0)
                            : 0,
                        child: Container(
                            height: 8, color: AppColors.arGoldBright),
                      ),
                    ],
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

/// 사막 언덕 + 모스크 돔·첨탑·초승달 실루엣.
class _SkylinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dune = Paint()
      ..color = AppColors.arGreenDeep
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, size.height)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.55,
          size.width * 0.5, size.height * 0.75)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.95,
          size.width, size.height * 0.7)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, dune);

    final gold = Paint()
      ..color = AppColors.arGoldBright.withValues(alpha: 0.85);
    // 첨탑(minaret)
    canvas.drawRect(
        Rect.fromLTWH(
            size.width * 0.62, size.height * 0.18, 4, size.height * 0.5),
        gold);
    canvas.drawCircle(
        Offset(size.width * 0.62 + 2, size.height * 0.16), 3.5, gold);
    // 돔(dome)
    final domeCenter = Offset(size.width * 0.8, size.height * 0.55);
    canvas.drawArc(Rect.fromCircle(center: domeCenter, radius: 16), math.pi,
        math.pi, true, gold);
    canvas.drawRect(
        Rect.fromLTWH(
            domeCenter.dx - 16, domeCenter.dy, 32, size.height * 0.2),
        gold);
    // 초승달
    final moonC = Offset(size.width * 0.3, size.height * 0.22);
    canvas.drawCircle(moonC, 9, gold);
    canvas.drawCircle(Offset(moonC.dx + 4, moonC.dy - 2), 8,
        Paint()..color = AppColors.arGreenDeep);
  }

  @override
  bool shouldRepaint(_) => false;
}

/// 🔥 연속 학습 칩.
class StreakChip extends StatelessWidget {
  final int days;
  const StreakChip({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.arGreenDeep,
        border: Border.all(color: AppColors.arGoldBright, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            '$days',
            style: const TextStyle(
              color: AppColors.arGoldBright,
              fontWeight: FontWeight.w900,
              fontSize: 13,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

/// 섹션 제목 — 인장 + 라벨.
class SectionTitle extends StatelessWidget {
  final String seal;
  final String label;
  final Widget? trailing;
  const SectionTitle(
      {super.key, required this.seal, required this.label, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ArabicSeal(text: seal, size: 22),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.arInk,
              letterSpacing: 2,
            ),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
