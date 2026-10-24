import 'package:flutter/material.dart';
import 'package:swastha/models/data_model.dart';
import 'package:swastha/models/metric.dart';
import 'package:swastha/models/user_model.dart';
import 'package:swastha/utils/styles.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Concentric rings for water, steps, sleep and calories with a legend.
class ProgressRings extends StatelessWidget {
  final DataModel data;
  final UserModel user;

  const ProgressRings({super.key, required this.data, required this.user});

  static const _radii = [1.0, 0.83, 0.73, 0.63];

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
    final size = MediaQuery.sizeOf(context).width / 2;
    return Column(
      children: [
        Semantics(
          label: 'Overall daily goal progress $overallPercent percent',
          child: SizedBox(
            height: size,
            width: size,
            child: SfRadialGauge(
              enableLoadingAnimation: true,
              axes: [
                for (var i = 0; i < _order.length; i++) _ring(i, _order[i]),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          runSpacing: 4,
          alignment: WrapAlignment.center,
          children: [
            for (final metric in _order)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, size: 12, color: metric.color),
                  const SizedBox(width: 4),
                  Text(metric.label, style: kNormalTextStyle),
                ],
              ),
          ],
        ),
      ],
    );
  }

  RadialAxis _ring(int index, Metric metric) {
    final goal = metric.goal(user);
    return RadialAxis(
      startAngle: 90,
      endAngle: 90,
      radiusFactor: _radii[index],
      canScaleToFit: false,
      minimum: 0,
      maximum: goal,
      showLabels: false,
      showTicks: false,
      axisLineStyle: AxisLineStyle(
        thickness: 0.1,
        cornerStyle: CornerStyle.bothCurve,
        color: metric.color.withValues(alpha: 0.3),
        thicknessUnit: GaugeSizeUnit.factor,
      ),
      pointers: <GaugePointer>[
        RangePointer(
          value: metric.today(data).clamp(0, goal).toDouble(),
          cornerStyle: CornerStyle.bothCurve,
          width: 0.1,
          sizeUnit: GaugeSizeUnit.factor,
          color: metric.color,
        ),
      ],
      annotations: index == 0
          ? <GaugeAnnotation>[
              GaugeAnnotation(
                positionFactor: 0.1,
                angle: 90,
                widget: Text(
                  '$overallPercent%',
                  style: kHeadingTextStyle.copyWith(
                    color: kPrimaryColor,
                    fontSize: 30.0,
                  ),
                ),
              ),
            ]
          : null,
    );
  }
}
