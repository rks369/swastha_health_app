import 'package:fl_chart/fl_chart.dart' hide GaugePointer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swastha/Bloc/auth_cubit.dart';
import 'package:swastha/database/sql_helper.dart';
import 'package:swastha/models/metric.dart';
import 'package:swastha/utils/constants.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/app_page.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
              child: SizedBox(
                height: gaugeSize,
                width: gaugeSize,
                child: SfRadialGauge(
                  enableLoadingAnimation: true,
                  axes: <RadialAxis>[
                    RadialAxis(
                      startAngle: 90,
                      endAngle: 90,
                      canScaleToFit: false,
                      minimum: 0,
                      maximum: goal,
                      showLabels: false,
                      showTicks: false,
                      axisLineStyle: AxisLineStyle(
                        thickness: 0.2,
                        cornerStyle: CornerStyle.bothCurve,
                        color: metric.color.withValues(alpha: 0.3),
                        thicknessUnit: GaugeSizeUnit.factor,
                      ),
                      pointers: <GaugePointer>[
                        RangePointer(
                          value: today.clamp(0, goal).toDouble(),
                          cornerStyle: CornerStyle.bothCurve,
                          width: 0.2,
                          sizeUnit: GaugeSizeUnit.factor,
                          color: metric.color,
                        ),
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                          positionFactor: 0.1,
                          angle: 90,
                          widget: Text(
                            '${metric.format(today)}/${metric.format(goal)}',
                            style: kHeadingTextStyle.copyWith(
                              color: metric.color,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text('Last 7 days', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                color: const Color(0xff020227),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: weekly,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'Could not load data',
                            style: TextStyle(color: kWhite),
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
                            style: const TextStyle(color: kWhite),
                          ),
                        );
                      }
                      return buildChart(rows, goal);
                    },
                  ),
                ),
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
    const labelStyle = TextStyle(color: kWhite, fontSize: 11);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: highest * 1.2,
        minY: 0,
        barTouchData: BarTouchData(enabled: true),
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
                  width: 14,
                  color: barColor[i % barColor.length],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
