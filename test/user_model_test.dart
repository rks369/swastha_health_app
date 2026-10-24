import 'package:flutter_test/flutter_test.dart';
import 'package:swastha/models/metric.dart';
import 'package:swastha/models/data_model.dart';
import 'package:swastha/models/user_model.dart';

UserModel buildUser({
  String dob = '',
  String age = '30',
  String goalWater = '3',
  String goalSteps = '6000',
}) {
  return UserModel('uid', '123', 'Test User', '', 'Male', dob, '170', '65', age,
      '22.5', goalWater, goalSteps, '8', '2200');
}

void main() {
  group('UserModel', () {
    test('uses the stored age when there is no date of birth', () {
      expect(buildUser().currentAge, 30);
    });

    test('derives the age from the date of birth when present', () {
      final dob = DateTime.now().subtract(const Duration(days: 365 * 20 + 10));
      final user = buildUser(dob: dob.toIso8601String().substring(0, 10));
      expect(user.currentAge, 20);
    });

    test('falls back to defaults for missing or non-positive goals', () {
      final user = buildUser(goalWater: '', goalSteps: '0');
      expect(user.goalWaterLiters, 3);
      expect(user.goalStepsCount, 6000);
    });

    test('round-trips dob through JSON', () {
      final user = buildUser(dob: '1999-04-02');
      expect(userModelFromJSON(user.toJSON()).dob, '1999-04-02');
    });
  });

  group('Metric', () {
    test('converts stored millilitres to litres', () {
      expect(Metric.water.fromRow({'water': 1500}), 1.5);
      expect(Metric.water.today(DataModel('d', 1, 2500, 0, 0, 0)), 2.5);
    });

    test('formats values with their unit', () {
      expect(Metric.water.format(1.5), '1.5L');
      expect(Metric.steps.format(4200), '4200');
      expect(Metric.sleep.format(8), '8h');
    });
  });
}
