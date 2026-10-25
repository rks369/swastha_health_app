import 'package:flutter/material.dart';
import 'package:swastha/models/data_model.dart';
import 'package:swastha/models/user_model.dart';

enum Metric {
  water('Water', 'L', Icons.water_drop, Color(0xff3fa7f5), 'water', 1000),
  steps('Steps', '', Icons.directions_run, Color(0xff4cc38a), 'steps', 1),
  sleep('Sleep', 'h', Icons.hotel, Color(0xff5e72e4), 'sleep', 1),
  calories(
    'Calorie',
    'kcal',
    Icons.local_dining,
    Color(0xffffa94d),
    'calories',
    1,
  );

  const Metric(
    this.label,
    this.unit,
    this.icon,
    this.color,
    this.column,
    this.divisor,
  );

  final String label;
  final String unit;
  final IconData icon;
  final Color color;
  final String column;

  /// Raw stored value divided by this gives the displayed value (ml -> L).
  final double divisor;

  double fromRow(Map<String, dynamic> row) =>
      ((row[column] as num?) ?? 0) / divisor;

  double today(DataModel data) => switch (this) {
    Metric.water => data.water / divisor,
    Metric.steps => data.steps.toDouble(),
    Metric.sleep => data.sleep.toDouble(),
    Metric.calories => data.calories.toDouble(),
  };

  double goal(UserModel user) => switch (this) {
    Metric.water => user.goalWaterLiters,
    Metric.steps => user.goalStepsCount,
    Metric.sleep => user.goalSleepHours,
    Metric.calories => user.goalCalorieKcal,
  };

  String format(double value) {
    final text = value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
    return unit.isEmpty ? text : '$text$unit';
  }
}
