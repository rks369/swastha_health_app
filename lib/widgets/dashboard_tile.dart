import 'package:flutter/material.dart';
import 'package:swastha/models/metric.dart';
import 'package:swastha/utils/styles.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DashboardTile extends StatelessWidget {
  final Metric metric;
  final double value;
  final double goal;
  final VoidCallback? onTap;

  const DashboardTile({
    super.key,
    required this.metric,
    required this.value,
    required this.goal,
    this.onTap,
  });

  ({String text, Color color, IconData icon}) get status {
    if (value >= goal) {
      return (text: 'Done', color: Colors.green, icon: Icons.check_circle);
    }
    if (value <= goal / 3) {
      return (text: 'Low', color: Colors.red, icon: Icons.warning_amber);
    }
    return (text: 'Good', color: Colors.orange, icon: Icons.trending_up);
  }

  @override
  Widget build(BuildContext context) {
    final current = status;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Semantics(
        button: true,
        label:
            '${metric.label} ${metric.format(value)} of ${metric.format(goal)}, ${current.text}',
        child: Material(
          color: kWhite,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(metric.icon, color: metric.color, size: 30),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${metric.label}: '
                                '${metric.format(value)}/${metric.format(goal)}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(current.icon, color: current.color, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              current.text,
                              style: TextStyle(
                                color: current.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SfLinearGauge(
                          showTicks: false,
                          showLabels: false,
                          minimum: 0.0,
                          maximum: goal,
                          animateAxis: true,
                          animateRange: true,
                          markerPointers: [
                            LinearShapePointer(
                              value: value.clamp(0, goal).toDouble(),
                              color: metric.color,
                            ),
                          ],
                          axisTrackStyle: LinearAxisTrackStyle(
                            gradient: LinearGradient(
                              colors: [
                                metric.color.withValues(alpha: 0.4),
                                metric.color,
                              ],
                            ),
                            color: kGrey,
                            edgeStyle: LinearEdgeStyle.bothCurve,
                            thickness: 15.0,
                            borderColor: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
