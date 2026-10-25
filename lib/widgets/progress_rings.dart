import 'package:flutter/material.dart';
import 'package:swastha/models/data_model.dart';
import 'package:swastha/models/metric.dart';
import 'package:swastha/models/user_model.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/ring_gauge.dart';

/// Concentric rings for water, steps, sleep and calories with a legend.
class ProgressRings extends StatelessWidget {
  final DataModel data;
  final UserModel user;

  const ProgressRings({super.key, required this.data, required this.user});

  static const _order = [
    Metric.water,
    Metric.steps,
    Metric.sleep,
    Metric.calories,
  ];

  int get overallPercent {
    final total = _order.fold<double>(0, (sum, metric) {
      final ratio = metric.today(data) / metric.goal(user);
      return sum + ratio.clamp(0.0, 1.0);
    });
    return (total / _order.length * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context).width * 0.55;
    return Column(
      children: [
        Semantics(
          label: 'Overall daily goal progress $overallPercent percent',
          child: RingGauge(
            size: size,
            rings: [
              for (final metric in _order)
                RingData(
                  value: metric.today(data),
                  max: metric.goal(user),
                  color: metric.color,
                ),
            ],
            center: Text(
              '$overallPercent%',
              style: kHeadingTextStyle.copyWith(fontSize: 24.0),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 20,
          runSpacing: 4,
          alignment: WrapAlignment.center,
          children: [
            for (final metric in _order)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, size: 8, color: metric.color),
                  const SizedBox(width: 6),
                  Text(metric.label, style: kNormalTextStyle),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
