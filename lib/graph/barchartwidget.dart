import 'dart:ffi';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:swastha/database/sql_helper.dart';
import 'package:swastha/models/graph_data.dart';
import 'package:swastha/utils/constants.dart';
import 'package:swastha/utils/styles.dart';

class BarChartWidget extends StatefulWidget {
  const BarChartWidget({Key? key}) : super(key: key);

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  final List<GraphData> dataList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final List<Map<String, dynamic>> result = await SQLHelper.getItems();

    for (int i = 0; i < result.length; i++) {
      dataList.add(GraphData(
          name: result[i]['date'],
          id: i,
          y: result[i]['waterTaken'] * 1.0,
          color: barColor[i % 7]));
    }
    setState(() {
      print(dataList);
      print(result.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(BarChartData(
      alignment: BarChartAlignment.center,
      maxY: 1200,
      minY: 0,
      groupsSpace: 36,
      barTouchData: BarTouchData(enabled: true),
      titlesData: FlTitlesData(
        show: true,
        // rightTitles: AxisTitles(
        //     sideTitles: SideTitles(
        //         showTitles: true,
        //         getTitlesWidget: ((value, meta) {
        //           return Text((dataList[(value.toInt())].y.toString()),
        //               style: const TextStyle(color: kWhite));
        //         }))),
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: ((value, meta) {
                  return Text(dataList[value.toInt()].name,
                      style: const TextStyle(color: kWhite));
                }))),
      ),
      barGroups: dataList.map((data) {
        return BarChartGroupData(
          x: data.id,
          barRods: [
            BarChartRodData(
              toY: data.y,
              width: 12,
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
}
