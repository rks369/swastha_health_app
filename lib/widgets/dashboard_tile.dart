import 'package:flutter/material.dart';
import 'package:swastha/models/metric.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/progress_bar.dart';

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

  ({String text, Color color}) get status {
    if (value >= goal) return (text: 'Done', color: Colors.green);
    if (value <= goal / 3) return (text: 'Low', color: Colors.red);
    return (text: 'Good', color: Colors.orange);
  }

  @override
  Widget build(BuildContext context) {
    final current = status;
    const radius = BorderRadius.all(Radius.circular(kRadius));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Semantics(
        button: true,
        label:
            '${metric.label} ${metric.format(value)} of ${metric.format(goal)}, ${current.text}',
        child: Material(
          color: kWhite,
          shape: const RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(color: kBorder),
          ),
          child: InkWell(
            borderRadius: radius,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: metric.color.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(metric.icon, color: metric.color, size: 22),
                  ),
                  const SizedBox(width: 16),
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
                                  color: kInk,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              current.text,
                              style: TextStyle(
                                color: current.color,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ProgressBar(
                          value: value,
                          max: goal,
                          color: metric.color,
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
