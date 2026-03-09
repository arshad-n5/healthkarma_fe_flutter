// lib/widgets/success_checkmark.dart
//
// Flat green checkmark (no circle) with yellow 4-pointed sparkles.
// Matches the design exactly.

import 'dart:math' as math;
import 'package:flutter/material.dart';

class SuccessCheckmark extends StatefulWidget {
  final double size;
  const SuccessCheckmark({super.key, this.size = 120});

  @override
  State<SuccessCheckmark> createState() => _SuccessCheckmarkState();
}

class _SuccessCheckmarkState extends State<SuccessCheckmark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _checkAnim;
  late final Animation<double> _sparkleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _checkAnim = CurvedAnimation(
      parent: _ctrl,
      curve:  const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );
    _sparkleAnim = CurvedAnimation(
      parent: _ctrl,
      curve:  const Interval(0.45, 1.0, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => CustomPaint(
        size: Size(widget.size * 1.8, widget.size * 1.6),
        painter: _CheckmarkWithSparklePainter(
          checkProgress:   _checkAnim.value,
          sparkleProgress: _sparkleAnim.value,
          baseSize:        widget.size,
        ),
      ),
    );
  }
}

class _CheckmarkWithSparklePainter extends CustomPainter {
  final double checkProgress;
  final double sparkleProgress;
  final double baseSize;

  _CheckmarkWithSparklePainter({
    required this.checkProgress,
    required this.sparkleProgress,
    required this.baseSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width  / 2;
    final cy = size.height / 2;

    // ── Draw sparkles first (behind checkmark) ──
    if (sparkleProgress > 0) {
      _drawAllSparkles(canvas, cx, cy);
    }

    // ── Draw the flat checkmark ──────────────────
    if (checkProgress > 0) {
      _drawCheckmark(canvas, cx, cy);
    }
  }

  // ── Flat filled checkmark (two rounded arms) ──
  void _drawCheckmark(Canvas canvas, double cx, double cy) {
    final s = baseSize * 0.42 * checkProgress;

    // checkmark stroke — thick rounded
    final paint = Paint()
      ..color      = const Color(0xFF7ED957)
      ..style      = PaintingStyle.stroke
      ..strokeCap  = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = s * 0.42;

    final path = Path();

    // Left short arm: goes down-left
    final leftX  = cx - s * 0.65;
    final leftY  = cy + s * 0.10;
    final midX   = cx - s * 0.05;
    final midY   = cy + s * 0.72;
    // Right long arm: goes up-right
    final rightX = cx + s * 1.05;
    final rightY = cy - s * 0.55;

    path.moveTo(leftX, leftY);
    path.lineTo(midX,  midY);
    path.lineTo(rightX, rightY);

    canvas.save();
    // Slight tilt to match design (-8 degrees)
    canvas.translate(cx, cy);
    canvas.rotate(-0.14);
    canvas.translate(-cx, -cy);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  // ── All sparkles ──────────────────────────────
  void _drawAllSparkles(Canvas canvas, double cx, double cy) {
    // Positions from design:
    // top-left: 2 sparkles (small above, larger below-right of it)
    // bottom-right: 1 sparkle
    // Each: [dx, dy, outerRadius, stagger]
    final sparkles = [
      // top-left small star
      [-0.50 * baseSize, -0.52 * baseSize, baseSize * 0.095, 0.00],
      // top-left larger star
      [-0.22 * baseSize, -0.72 * baseSize, baseSize * 0.145, 0.08],
      // bottom-right star
      [ 0.52 * baseSize,  0.28 * baseSize, baseSize * 0.115, 0.15],
    ];

    for (final sp in sparkles) {
      final dx      = sp[0] as double;
      final dy      = sp[1] as double;
      final r       = sp[2] as double;
      final stagger = sp[3] as double;

      final p = ((sparkleProgress - stagger) / (1.0 - stagger))
          .clamp(0.0, 1.0);
      if (p <= 0) continue;

      _drawStar(
        canvas,
        cx + dx,
        cy + dy,
        r * p,
        const Color(0xFFFFD04B).withOpacity(p),
      );
    }
  }

  // ── 4-pointed star ────────────────────────────
  void _drawStar(Canvas canvas, double cx, double cy, double outerR, Color color) {
    final innerR = outerR * 0.22;
    final path   = Path();

    for (int i = 0; i < 8; i++) {
      final angle  = (i * math.pi / 4) - math.pi / 2;
      final radius = i.isEven ? outerR : innerR;
      final px     = cx + math.cos(angle) * radius;
      final py     = cy + math.sin(angle) * radius;
      i == 0 ? path.moveTo(px, py) : path.lineTo(px, py);
    }
    path.close();

    canvas.drawPath(path, Paint()
      ..color = color
      ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(_CheckmarkWithSparklePainter old) =>
      old.checkProgress   != checkProgress ||
      old.sparkleProgress != sparkleProgress;
}