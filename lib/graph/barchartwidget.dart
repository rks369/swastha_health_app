import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:swastha/graph/bardata.dart';
import 'package:swastha/utils/styles.dart';

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BarChart(BarChartData(
        alignment: BarChartAlignment.center,
        maxY: 20,
        minY: 0,
        groupsSpace: 20,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: ((value, meta) {
                    return Text(
                        (BarData.barData[(value.toInt() % 7)].y.toString()),
                        style: const TextStyle(color: kWhite));
                  }))),
          topTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: ((value, meta) {
                    return Text(BarData.barData[value.toInt()].name,
                        style: const TextStyle(color: kWhite));
                  }))),
        ),
        barGroups: BarData.barData.map((data) {
          return BarChartGroupData(
            x: data.id,
            barRods: [
              BarChartRodData(
                toY: data.y,
                width: 5,
                color: data.color,
                borderRadius: data.y > 0
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      )
                    : const BorderRadius.only(
                        bottomLeft: Radius.circular(6),
                        bottomRight: Radius.circular(6),
                      ),
              ),
            ],
          );
        }).toList(),
      ));
}
