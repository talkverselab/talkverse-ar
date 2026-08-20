import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 베트남어 6 성조 곡선 시각화 위젯.
///
/// `assets/UXUI/flashcard/tone-curve.jsx` 를 Flutter CustomPainter 로 포팅.
/// SVG path → Canvas Path API.
///
/// 사용:
///   ToneCurve(tone: 'ngang', size: 32)
///   ToneCurve(tone: 'hoi', size: 64, showLabel: true)
///
/// 남부 dialect 시 ngã → hỏi 자동 매핑.
class ToneCurve extends StatelessWidget {
  /// 'ngang' | 'huyen' | 'sac' | 'hoi' | 'nga' | 'nang'
  final String tone;
  final double size;
  final bool showLabel;
  /// 'north' (6성) | 'south' (5성, ngã→hỏi 통합)
  final String dialect;

  const ToneCurve({
    super.key,
    required this.tone,
    this.size = 32,
    this.showLabel = false,
    this.dialect = 'north',
  });

  /// tone → 라벨/분음부호 표시.
  /// v2 학술 색상 (ToneComparisonChart 차트용).
  static const Map<String, Color> _toneColors = {
    'ngang': Color(0xFF4A9B7F),
    'huyen': Color(0xFF7EB8D4),
    'sac':   Color(0xFFE8A87C),
    'nang':  Color(0xFFC0856A),
    'hoi':   Color(0xFF9B7FD4),
    'nga':   Color(0xFFD4609B),
  };

  static const Map<String, ({String label, String mark})> _meta = {
    'ngang': (label: 'ngang', mark: '·'),
    'huyen': (label: 'huyền', mark: '̀'),
    'sac': (label: 'sắc', mark: '́'),
    'hoi': (label: 'hỏi', mark: '̉'),
    'nga': (label: 'ngã', mark: '̃'),
    'nang': (label: 'nặng', mark: '̣'),
  };

  @override
  Widget build(BuildContext context) {
    String t = tone;
    // 남부 통합
    if (dialect == 'south' && t == 'nga') t = 'hoi';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: Size(size, size * 0.875),
          painter: _ToneCurvePainter(tone: t),
        ),
        if (showLabel) ...[
          const SizedBox(height: 2),
          Text(
            '${_meta[t]?.mark ?? '·'} ${_meta[t]?.label ?? ''}',
            style: GoogleFonts.notoSans(
              fontSize: size * 0.18,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1F3A6E).withValues(alpha: 0.8),
            ),
          ),
        ],
      ],
    );
  }
}

/// v3 spec 기반 단일 톤 painter — pitch 0-150 좌표 + bezier 곡선 + ✂ 끊김 + ngã 두 segment.
class _ToneCurvePainter extends CustomPainter {
  final String tone;
  _ToneCurvePainter({required this.tone});

  @override
  void paint(Canvas canvas, Size size) {
    final spec = _toneSpecs[tone];
    if (spec == null) return;
    final color =
        ToneCurve._toneColors[tone] ?? const Color(0xFF1F3A6E);

    final padTop = size.height * 0.12;
    final padBot = size.height * 0.12;
    final padX = size.width * 0.08;
    final drawW = size.width - padX * 2;

    double pitchToY(double pitch) {
      final drawH = size.height - padTop - padBot;
      return padTop + drawH * (1 - pitch / 150);
    }

    Offset xy(({double t, double y}) p) =>
        Offset(padX + p.t * drawW, pitchToY(p.y));

    final stroke = (size.width * 0.07).clamp(1.5, 4.0);
    final paint = Paint()
      ..color = color
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    /// 사용자 결정 2026-05-09: 직선 line.
    Path bezier(List<({double t, double y})> pts) {
      final path = Path();
      for (int i = 0; i < pts.length; i++) {
        final p = xy(pts[i]);
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      return path;
    }

    canvas.drawPath(bezier(spec.points), paint);
    if (spec.points2 != null) {
      canvas.drawPath(bezier(spec.points2!), paint);
    }

    // ✂ 끊김 — 작은 사이즈는 X 사선, 큰 사이즈는 ✂ 텍스트
    if (spec.cut != null) {
      final lastY = spec.points.last.y;
      final cutPos = Offset(padX + spec.cut! * drawW, pitchToY(lastY));
      if (size.width >= 60) {
        final tp = TextPainter(
          text: TextSpan(
            text: '✂',
            style: TextStyle(fontSize: size.width * 0.22, color: color),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, cutPos.translate(-tp.width / 2, -tp.height / 2));
      } else {
        final cutPaint = Paint()
          ..color = color
          ..strokeWidth = (size.width * 0.05).clamp(1.0, 2.0)
          ..strokeCap = StrokeCap.round;
        final r = size.width * 0.08;
        canvas.drawLine(
            cutPos.translate(-r, -r), cutPos.translate(r, r), cutPaint);
        canvas.drawLine(
            cutPos.translate(-r, r), cutPos.translate(r, -r), cutPaint);
      }
    }

    // 시작점 dot
    final startPt = xy(spec.points.first);
    canvas.drawCircle(startPt, stroke * 0.9, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_ToneCurvePainter old) => old.tone != tone;
}

/// 톤 spec — pitch 0-150 좌표 (ngang=100 기준), 끊김 cut, ngã 두번째 segment.
class _ToneSpec {
  final List<({double t, double y})> points;
  final double? cut;
  final List<({double t, double y})>? points2;
  const _ToneSpec({required this.points, this.cut, this.points2});
}

/// 학술 기반 성조 높이 수치 (ngang=100 기준).
/// 사용자 결정 2026-05-09 — 정확한 학술 수치 적용:
///   ngang  100 / 100 / 100  평평
///   huyền   70 /  60 /  45  낮게 하강 + breathy
///   sắc     80 / 110 / 130  중간서 시작 → 높게 상승
///   nặng    70 /  55 /  ✂  하강 후 글로탈 스톱
///   hỏi     70 /  45 /  85  낮게 내려갔다 중간 회복
///   ngã     80 /  ✂  / 135  상승 중 성대 꺾임 → 높게 끝
const _toneSpecs = <String, _ToneSpec>{
  'ngang': _ToneSpec(
    points: [(t: 0, y: 100), (t: 0.5, y: 100), (t: 1, y: 100)],
  ),
  'huyen': _ToneSpec(
    points: [(t: 0, y: 70), (t: 0.5, y: 60), (t: 1, y: 45)],
  ),
  'sac': _ToneSpec(
    points: [(t: 0, y: 80), (t: 0.5, y: 110), (t: 1, y: 130)],
  ),
  'nang': _ToneSpec(
    points: [(t: 0, y: 70), (t: 0.5, y: 55), (t: 0.75, y: 45)],
    cut: 0.75,
  ),
  'hoi': _ToneSpec(
    points: [(t: 0, y: 70), (t: 0.4, y: 45), (t: 1, y: 85)],
  ),
  'nga': _ToneSpec(
    points: [(t: 0, y: 80), (t: 0.45, y: 95)],
    cut: 0.45,
    points2: [(t: 0.6, y: 105), (t: 1, y: 135)],
  ),
};

/// 베트남어 6/5 성조 한눈 비교 차트 — `tone-curve-v2(1).jsx` 디자인.
/// 단일 큰 캔버스에 모든 톤 곡선을 가로 segment 별로 나란히 표시.
///
/// 특징:
/// - 그리드 라인 (pitch 40/60/80/100/120/140) + ngang=100 mint 강조선
/// - 좌측 pitch 숫자 라벨
/// - 각 톤: 시작 dot + 시작 pitch 라벨 + bezier 곡선 + ✂ 끊김 + 하단 톤 이름
/// - 남부(`dialect: 'south'`)면 ngã 제외 5 톤
class ToneComparisonChart extends StatelessWidget {
  final String dialect;
  final double height;
  const ToneComparisonChart({
    super.key,
    this.dialect = 'north',
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    final tones = dialect == 'south'
        ? const ['ngang', 'huyen', 'sac', 'hoi', 'nang']
        : const ['ngang', 'huyen', 'sac', 'hoi', 'nga', 'nang'];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAF8F3),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 6),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : 320.0;
            return CustomPaint(
              painter: _ToneComparisonPainter(tones: tones),
              size: Size(w, height),
            );
          },
        ),
      ),
    );
  }
}

class _ToneComparisonPainter extends CustomPainter {
  final List<String> tones;
  _ToneComparisonPainter({required this.tones});

  static const _ngangColor = Color(0xFF4A9B7F);
  static const _gridColor = Color(0xFFE8E3DA);
  static const _gridLabelColor = Color(0xFFAAAAAA);

  @override
  void paint(Canvas canvas, Size size) {
    const padTop = 24.0;
    const padBot = 24.0;
    const padLeft = 30.0;
    const padRight = 8.0;
    final w = size.width;
    final h = size.height;

    double pitchToY(double pitch) {
      final drawH = h - padTop - padBot;
      return padTop + drawH * (1 - pitch / 150);
    }

    // ==== 그리드 라인 (dashed) ====
    final dashPaint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    const gridPitches = [40.0, 60.0, 80.0, 100.0, 120.0, 140.0];
    for (final p in gridPitches) {
      final y = pitchToY(p);
      final isNgang = p == 100.0;
      // 사용자 결정 2026-05-09: 100 ngang 기준선 mint + 투명도, 점선.
      dashPaint
        ..color = isNgang
            ? _ngangColor.withValues(alpha: 0.45)
            : _gridColor
        ..strokeWidth = isNgang ? 1.5 : 1;
      _drawDashedLine(
        canvas,
        Offset(padLeft, y),
        Offset(w - padRight, y),
        dashPaint,
        isNgang ? 6 : 4,
        isNgang ? 4 : 4,
      );
      _drawText(
        canvas,
        '${p.toInt()}',
        Offset(2, y - 6),
        fontSize: isNgang ? 11 : 10,
        bold: isNgang,
        color: isNgang
            ? _ngangColor.withValues(alpha: 0.85)
            : _gridLabelColor,
      );
    }
    _drawText(
      canvas,
      '← ngang',
      Offset(padLeft + 4, pitchToY(100) - 16),
      fontSize: 10,
      color: _ngangColor,
    );

    // ==== 각 톤 segment ====
    final segW = (w - padLeft - padRight) / tones.length;
    for (int i = 0; i < tones.length; i++) {
      final tKey = tones[i];
      final spec = _toneSpecs[tKey];
      if (spec == null) continue;
      final color = ToneCurve._toneColors[tKey] ?? const Color(0xFF1F3A6E);
      final segLeft = padLeft + i * segW;
      final startX = segLeft + segW * 0.1;
      final endX = segLeft + segW * 0.9;
      final rangeX = endX - startX;

      Offset xy(({double t, double y}) p) =>
          Offset(startX + p.t * rangeX, pitchToY(p.y));

      final paint = Paint()
        ..color = color
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final path = _buildBezier(spec.points, xy);
      canvas.drawPath(path, paint);

      if (spec.points2 != null) {
        canvas.drawPath(_buildBezier(spec.points2!, xy), paint);
      }

      if (spec.cut != null) {
        final lastY = spec.points.last.y;
        final cutPos =
            Offset(startX + spec.cut! * rangeX, pitchToY(lastY));
        _drawText(
          canvas,
          '✂',
          cutPos.translate(-7, -8),
          fontSize: 14,
          color: color,
        );
      }

      final startPt = xy(spec.points.first);
      canvas.drawCircle(startPt, 4, Paint()..color = color);

      _drawText(
        canvas,
        '${spec.points.first.y.toInt()}',
        startPt.translate(-10, -16),
        fontSize: 10,
        bold: true,
        color: color,
      );

      final meta = ToneCurve._meta[tKey];
      _drawText(
        canvas,
        meta?.label ?? tKey,
        Offset(startX, h - 14),
        fontSize: 11,
        bold: true,
        color: color,
      );
    }
  }

  /// 사용자 결정 2026-05-09: 곡선 → 직선. 시작점→끝점 line.
  Path _buildBezier(
    List<({double t, double y})> pts,
    Offset Function(({double t, double y})) xy,
  ) {
    final path = Path();
    for (int i = 0; i < pts.length; i++) {
      final p = xy(pts[i]);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    return path;
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset a,
    Offset b,
    Paint paint,
    double dash,
    double gap,
  ) {
    final total = (b - a).distance;
    if (total <= 0) return;
    final dir = (b - a) / total;
    double drawn = 0;
    while (drawn < total) {
      final segEnd = (drawn + dash).clamp(0.0, total);
      canvas.drawLine(a + dir * drawn, a + dir * segEnd, paint);
      drawn += dash + gap;
    }
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset pos, {
    required double fontSize,
    bool bold = false,
    required Color color,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.w900 : FontWeight.w400,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(_ToneComparisonPainter old) =>
      old.tones.toString() != tones.toString();
}

/// (구) 6 성조 reference grid — 사용자 결정 2026-05-09: `ToneComparisonChart` 로 대체.
/// 호환성을 위해 그대로 두되, 신규 코드는 `ToneComparisonChart` 사용.
class ToneSystemGrid extends StatelessWidget {
  final String dialect;
  final double cellSize;
  const ToneSystemGrid({
    super.key,
    this.dialect = 'north',
    this.cellSize = 100,
  });

  static const _korNames = {
    'ngang': '평성',
    'huyen': '하강',
    'sac': '상승',
    'hoi': '굽이',
    'nga': '깨짐',
    'nang': '짧게 떨어짐',
  };

  static const _exampleKor = {
    'ngang': '낮은 평조',
    'huyen': '낮게 떨어짐',
    'sac': '높이 올라감',
    'hoi': 'á (내렸다 올라감)',
    'nga': 'á (끊어졌다 상승)',
    'nang': 'ạ (짧게 뚝)',
  };

  @override
  Widget build(BuildContext context) {
    final tones = dialect == 'south'
        ? ['ngang', 'huyen', 'sac', 'hoi', 'nang'] // 남부 5성조
        : ['ngang', 'huyen', 'sac', 'hoi', 'nga', 'nang'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            dialect == 'south' ? '베트남어 5성조 곡선 (남부)' : '베트남어 6성조 곡선',
            style: GoogleFonts.notoSans(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1F3A6E),
            ),
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.85,
          children: tones.map((t) => _toneCell(t)).toList(),
        ),
      ],
    );
  }

  Widget _toneCell(String t) {
    final meta = ToneCurve._meta[t]!;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ToneCurve(tone: t, size: cellSize * 0.55),
          const SizedBox(height: 2),
          Text(
            '${meta.mark} ${meta.label}',
            style: GoogleFonts.notoSans(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1F3A6E),
            ),
          ),
          Text(
            _korNames[t] ?? '',
            style: GoogleFonts.notoSans(
              fontSize: 11,
              color: const Color(0xFF1F3A6E).withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _exampleKor[t] ?? '',
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSans(
              fontSize: 9,
              color: const Color(0xFF1F3A6E).withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
