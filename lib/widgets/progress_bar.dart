import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double value;
  final double max;
  final Color color;
  final double height;

  const ProgressBar({
    super.key,
    required this.value,
    required this.max,
    required this.color,
    this.height = 6,
  });

  @override
  Widget build(BuildContext context) {
    final target = max <= 0 ? 0.0 : (value / max).clamp(0.0, 1.0);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: target),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (_, fraction, _) => ClipRRect(
        borderRadius: BorderRadius.circular(height),
        child: Container(
          height: height,
          color: color.withValues(alpha: 0.12),
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: fraction,
            child: Container(color: color),
          ),
        ),
      ),
    );
  }
}
