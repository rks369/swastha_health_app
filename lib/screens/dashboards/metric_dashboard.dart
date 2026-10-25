import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swastha/Bloc/auth_cubit.dart';
import 'package:swastha/database/sql_helper.dart';
import 'package:swastha/models/metric.dart';
import 'package:swastha/utils/constants.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/app_page.dart';
import 'package:swastha/widgets/ring_gauge.dart';

class MetricDashboard extends StatefulWidget {
  final Metric metric;
  const MetricDashboard({super.key, required this.metric});

  @override
  State<MetricDashboard> createState() => _MetricDashboardState();
}

class _MetricDashboardState extends State<MetricDashboard> {
  late final Future<List<Map<String, dynamic>>> weekly =
      SQLHelper.getWeeklyData();

  Metric get metric => widget.metric;

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<AuthCubit>(context);
    final goal = metric.goal(cubit.userModel);
    final today = metric.today(cubit.dataModel);
    final gaugeSize = MediaQuery.sizeOf(context).width / 2;

    return AppPage(
      title: '${metric.label} Dashboard',
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Semantics(
              label:
                  '${metric.label} today ${metric.format(today)} of ${metric.format(goal)}',
              child: RingGauge(
                size: gaugeSize,
                stroke: 0.09,
                rings: [RingData(value: today, max: goal, color: metric.color)],
                center: Text(
                  '${metric.format(today)}/${metric.format(goal)}',
                  style: kHeadingTextStyle.copyWith(fontSize: 20.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Last 7 days',
              style: TextStyle(
                color: kInk,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 300,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kWhite,
                border: Border.all(color: kBorder),
                borderRadius: BorderRadius.circular(kRadius),
              ),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: weekly,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Could not load data',
                        style: kSubHeadingTextStyle,
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final rows = snapshot.data!;
                  if (rows.every((row) => metric.fromRow(row) == 0)) {
                    return Center(
                      child: Text(
                        'No ${metric.label.toLowerCase()} logged yet',
                        style: kSubHeadingTextStyle,
                      ),
                    );
                  }
                  return buildChart(rows, goal);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChart(List<Map<String, dynamic>> rows, double goal) {
    final values = rows.map(metric.fromRow).toList();
    final highest = values.fold<double>(goal, (a, b) => a > b ? a : b);
    const labelStyle = TextStyle(color: kSecondaryColor, fontSize: 11);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: highest * 1.2,
        minY: 0,
        barTouchData: const BarTouchData(enabled: true),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          leftTitles: const AxisTitles(),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 44,
              getTitlesWidget: (value, meta) {
                if (value == meta.max) return const SizedBox.shrink();
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    value.toStringAsFixed(highest < 10 ? 1 : 0),
                    style: labelStyle,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= rows.length) {
                  return const SizedBox.shrink();
                }
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    weekday[(rows[index]['day'] as int) % 7],
                    style: labelStyle,
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < values.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i],
                  width: 12,
                  color: metric.color,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
