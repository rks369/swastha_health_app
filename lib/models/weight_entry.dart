import 'package:cloud_firestore/cloud_firestore.dart';

class WeightEntry {
  final DateTime date;
  final double weight;
  final double height;
  final double bmi;

  WeightEntry({
    required this.date,
    required this.weight,
    required this.height,
    required this.bmi,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'weight': weight,
      'height': height,
      'bmi': bmi,
    };
  }

  factory WeightEntry.fromMap(Map<String, dynamic> data) {
    return WeightEntry(
      date: (data['date'] as Timestamp).toDate(),
      weight: (data['weight'] as num).toDouble(),
      height: (data['height'] as num).toDouble(),
      bmi: (data['bmi'] as num).toDouble(),
    );
  }
}
