import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../db/app_database.dart';
// Chinese characters render via the platform CJK fallback — no web font fetch.
import '../theme/app_colors.dart';

/// Radial diagram: center radical + 1..8 related-character nodes arranged
/// in a circle, with lines from center to each outer node.
///
/// Colors (pastel):
///   - `semantic` (뜻을 가져옴) → blue
///   - `phonetic` (음을 가져옴) → pink
///
/// Tapping any node calls [onNodeTap] with the row (or `null` for center).
class HanziDiagram extends StatelessWidget {
  final HanziStudyZhRow center;
  final List<HanziRelatedZhRow> related;
  final void Function(HanziRelatedZhRow? node) onNodeTap;

  const HanziDiagram({
    super.key,
    required this.center,
    required this.related,
    required this.onNodeTap,
  });

  static const Color _semanticBg = Color(0xFFDCEEFB);
  static const Color _semanticBorder = Color(0xFF7FB3D5);
  static const Color _semanticText = Color(0xFF1A5276);

  static const Color _phoneticBg = Color(0xFFFDEBE4);
  static const Color _phoneticBorder = Color(0xFFE6A098);
  static const Color _phoneticText = Color(0xFF78281F);

  static const Color _centerBg = Colors.white;
  static const Color _centerBorder = Color(0xFF424242);

  static const double _centerSize = 110;
  static const double _outerSize = 80;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Reserve enough vertical space for diagram; require at least 320dp.
        final side = math.min(constraints.maxWidth, 360.0);
        final diagramSize = side.clamp(280.0, 360.0);

        final centerPt = Offset(diagramSize / 2, diagramSize / 2);
        final radius = diagramSize / 2 - _outerSize / 2 - 8;

        final count = related.length.clamp(1, 8);
        final visible = related.take(count).toList();

        final outerPositions = List<Offset>.generate(count, (i) {
          // First node at top (-pi/2), clockwise distribution.
          final angle = -math.pi / 2 + (i * 2 * math.pi / count);
          return Offset(
            centerPt.dx + radius * math.cos(angle),
            centerPt.dy + radius * math.sin(angle),
          );
        });

        return SizedBox(
          width: diagramSize,
          height: diagramSize,
          child: Stack(
            children: [
              // Connecting lines.
              Positioned.fill(
                child: CustomPaint(
                  painter: _LinesPainter(
                    center: centerPt,
                    outerCenters: outerPositions,
                    colors: visible
                        .map((r) => r.relationType == 'phonetic'
                            ? _phoneticBorder
                            : _semanticBorder)
                        .toList(),
                  ),
                ),
              ),
              // Outer nodes.
              for (var i = 0; i < count; i++)
                Positioned(
                  left: outerPositions[i].dx - _outerSize / 2,
                  top: outerPositions[i].dy - _outerSize / 2,
                  child: _OuterNode(
                    row: visible[i],
                    onTap: () => onNodeTap(visible[i]),
                  ),
                ),
              // Center node on top.
              Positioned(
                left: centerPt.dx - _centerSize / 2,
                top: centerPt.dy - _centerSize / 2,
                child: _CenterNode(
                  row: center,
                  onTap: () => onNodeTap(null),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LinesPainter extends CustomPainter {
  final Offset center;
  final List<Offset> outerCenters;
  final List<Color> colors;

  _LinesPainter({
    required this.center,
    required this.outerCenters,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < outerCenters.length; i++) {
      final paint = Paint()
        ..color = colors[i].withValues(alpha: 0.7)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;
      canvas.drawLine(center, outerCenters[i], paint);
    }
  }

  @override
  bool shouldRepaint(covariant _LinesPainter old) =>
      old.center != center ||
      old.outerCenters != outerCenters ||
      old.colors != colors;
}

class _CenterNode extends StatelessWidget {
  final HanziStudyZhRow row;
  final VoidCallback onTap;
  const _CenterNode({required this.row, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: HanziDiagram._centerSize,
        height: HanziDiagram._centerSize,
        decoration: BoxDecoration(
          color: HanziDiagram._centerBg,
          shape: BoxShape.circle,
          border: Border.all(color: HanziDiagram._centerBorder, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              row.radical,
              style: const TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              row.meaningKo,
              style: GoogleFonts.notoSans(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OuterNode extends StatelessWidget {
  final HanziRelatedZhRow row;
  final VoidCallback onTap;
  const _OuterNode({required this.row, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isPhonetic = row.relationType == 'phonetic';
    final bg = isPhonetic
        ? HanziDiagram._phoneticBg
        : HanziDiagram._semanticBg;
    final border = isPhonetic
        ? HanziDiagram._phoneticBorder
        : HanziDiagram._semanticBorder;
    final charColor = isPhonetic
        ? HanziDiagram._phoneticText
        : HanziDiagram._semanticText;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: HanziDiagram._outerSize,
        height: HanziDiagram._outerSize,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(color: border, width: 2),
          boxShadow: [
            BoxShadow(
              color: border.withValues(alpha: 0.25),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              row.character,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: charColor,
                height: 1.0,
              ),
            ),
            if (row.pinyin.isNotEmpty)
              Text(
                row.pinyin,
                style: GoogleFonts.notoSans(
                  fontSize: 10,
                  color: charColor.withValues(alpha: 0.8),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
