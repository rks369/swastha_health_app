import 'dart:math' as math;

import 'package:flutter/material.dart';

class RingData {
  final double value;
  final double max;
  final Color color;

  const RingData({required this.value, required this.max, required this.color});

  double get progress => max <= 0 ? 0 : (value / max).clamp(0.0, 1.0);
}

/// Concentric progress rings, outermost first. [stroke] and [gap] are
/// fractions of [size].
class RingGauge extends StatelessWidget {
  final List<RingData> rings;
  final double size;
  final double stroke;
  final double gap;
  final Widget? center;

  const RingGauge({
    super.key,
    required this.rings,
    required this.size,
    this.stroke = 0.05,
    this.gap = 0.03,
    this.center,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        builder: (_, t, child) => CustomPaint(
          painter: _RingPainter(rings, t, stroke * size, gap * size),
          child: child,
        ),
        child: Center(child: center),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final List<RingData> rings;
  final double t;
  final double stroke;
  final double gap;

  _RingPainter(this.rings, this.t, this.stroke, this.gap);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    var radius = size.shortestSide / 2 - stroke / 2;

    for (final ring in rings) {
      final track = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = ring.color.withValues(alpha: 0.12);
      canvas.drawCircle(center, radius, track);

      final sweep = 2 * math.pi * ring.progress * t;
      if (sweep > 0) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          -math.pi / 2,
          sweep,
          false,
          track..color = ring.color,
        );
      }
      radius -= stroke + gap;
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.t != t || old.rings != rings || old.stroke != stroke;
}
