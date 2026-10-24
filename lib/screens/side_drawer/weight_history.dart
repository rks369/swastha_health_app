import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:swastha/Bloc/auth_cubit.dart';
import 'package:swastha/models/weight_entry.dart';
import 'package:swastha/utils/body_metrics.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/app_page.dart';

enum _Metric { weight, bmi }

class WeightHistory extends StatefulWidget {
  const WeightHistory({super.key});

  @override
  State<WeightHistory> createState() => _WeightHistoryState();
}

class _WeightHistoryState extends State<WeightHistory> {
  late final Stream<List<WeightEntry>> history = BlocProvider.of<AuthCubit>(
    context,
  ).weightHistory();
  _Metric metric = _Metric.weight;

  double valueOf(WeightEntry entry) =>
      metric == _Metric.weight ? entry.weight : entry.bmi;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Weight & BMI History',
      child: StreamBuilder<List<WeightEntry>>(
        stream: history,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Could not load history'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final entries = snapshot.data!;
          if (entries.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No entries yet. Calculate your BMI and save it to start '
                  'tracking.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return buildContent(entries);
        },
      ),
    );
  }

  Widget buildContent(List<WeightEntry> entries) {
    final reversed = entries.reversed.toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SegmentedButton<_Metric>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: _Metric.weight, label: Text('Weight (kg)')),
              ButtonSegment(value: _Metric.bmi, label: Text('BMI')),
            ],
            selected: {metric},
            onSelectionChanged: (value) => setState(() => metric = value.first),
          ),
        ),
        SizedBox(
          height: 220,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
            child: buildChart(entries),
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: reversed.length,
            itemBuilder: (context, index) {
              final entry = reversed[index];
              final previous = index + 1 < reversed.length
                  ? reversed[index + 1]
                  : null;
              return buildTile(entry, previous);
            },
          ),
        ),
      ],
    );
  }

  Widget buildChart(List<WeightEntry> entries) {
    final values = entries.map(valueOf).toList();
    final minY = (values.reduce((a, b) => a < b ? a : b) - 2).floorToDouble();
    final maxY = (values.reduce((a, b) => a > b ? a : b) + 2).ceilToDouble();
    final dateFormat = DateFormat('d MMM');
    return LineChart(
      LineChartData(
        minY: minY,
        maxY: maxY,
        gridData: const FlGridData(drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                if (value == meta.min || value == meta.max) {
                  return const SizedBox.shrink();
                }
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    value.toStringAsFixed(0),
                    style: const TextStyle(fontSize: 11),
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: entries.length > 5
                  ? (entries.length / 4).ceilToDouble()
                  : 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (value != index.toDouble() ||
                    index < 0 ||
                    index >= entries.length) {
                  return const SizedBox.shrink();
                }
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    dateFormat.format(entries[index].date),
                    style: const TextStyle(fontSize: 11),
                  ),
                );
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < entries.length; i++)
                FlSpot(i.toDouble(), values[i]),
            ],
            isCurved: true,
            color: kPrimaryColor,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: kPrimaryColor.withValues(alpha: 0.15),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTile(WeightEntry entry, WeightEntry? previous) {
    final change = previous == null ? null : entry.weight - previous.weight;
    final date = DateFormat('d MMM yyyy').format(entry.date);
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: kPrimaryColor,
        child: Icon(Icons.monitor_weight, color: kWhite),
      ),
      title: Text('${entry.weight.toStringAsFixed(1)} kg'),
      subtitle: Text(
        '$date  •  BMI ${entry.bmi.toStringAsFixed(1)} (${bmiCategory(entry.bmi)})',
      ),
      trailing: change == null || change == 0
          ? null
          : Text(
              '${change > 0 ? '+' : ''}${change.toStringAsFixed(1)}',
              style: TextStyle(
                color: change > 0 ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
