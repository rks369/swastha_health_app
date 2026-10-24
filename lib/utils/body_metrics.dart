import 'dart:math';

double calculateBmi(double weightKg, double heightCm) {
  return weightKg / pow(heightCm / 100, 2);
}

String bmiCategory(double bmi) {
  if (bmi >= 25) return 'Overweight';
  if (bmi > 18.5) return 'Normal';
  return 'Underweight';
}

String bmiInterpretation(double bmi) {
  if (bmi >= 25) {
    return 'You have a higher than normal body weight. Try to exercise more.';
  }
  if (bmi >= 18.5) {
    return 'You have a normal body weight. Good job!';
  }
  return 'You have a lower than normal body weight. You can eat a bit more.';
}

int ageFromDob(DateTime dob, [DateTime? today]) {
  final now = today ?? DateTime.now();
  var age = now.year - dob.year;
  if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
    age--;
  }
  return age;
}
