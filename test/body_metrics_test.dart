import 'package:flutter_test/flutter_test.dart';
import 'package:swastha/utils/body_metrics.dart';

void main() {
  group('calculateBmi', () {
    test('divides weight by height in metres squared', () {
      expect(calculateBmi(70, 175), closeTo(22.86, 0.01));
    });
  });

  group('bmiCategory', () {
    test('classifies the boundaries', () {
      expect(bmiCategory(18.5), 'Underweight');
      expect(bmiCategory(18.6), 'Normal');
      expect(bmiCategory(24.9), 'Normal');
      expect(bmiCategory(25), 'Overweight');
    });
  });

  group('ageFromDob', () {
    final today = DateTime(2026, 6, 15);

    test('counts a full year once the birthday has passed', () {
      expect(ageFromDob(DateTime(2000, 6, 15), today), 26);
      expect(ageFromDob(DateTime(2000, 1, 1), today), 26);
    });

    test('does not count the year before the birthday', () {
      expect(ageFromDob(DateTime(2000, 6, 16), today), 25);
      expect(ageFromDob(DateTime(2000, 12, 31), today), 25);
    });
  });
}
