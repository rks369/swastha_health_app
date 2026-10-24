import 'package:swastha/utils/body_metrics.dart';

class UserModel {
  final String uid;
  final String mobile;
  String name;
  final String profileURL;
  final String gender;
  final String dob;
  String height;
  String weight;
  final String age;
  String bmi;
  String goalWater;
  String goalSteps;
  String goalSleep;
  String goalCalorie;

  UserModel(
    this.uid,
    this.mobile,
    this.name,
    this.profileURL,
    this.gender,
    this.dob,
    this.height,
    this.weight,
    this.age,
    this.bmi,
    this.goalWater,
    this.goalSteps,
    this.goalSleep,
    this.goalCalorie,
  );

  DateTime? get dobDate => DateTime.tryParse(dob);

  int get currentAge {
    final date = dobDate;
    if (date != null) return ageFromDob(date);
    return int.tryParse(age.split('.').first) ?? 18;
  }

  static double _positive(String value, double fallback) {
    final parsed = double.tryParse(value);
    return parsed != null && parsed > 0 ? parsed : fallback;
  }

  double get heightCm => _positive(height, 170);
  double get weightKg => _positive(weight, 50);
  double get goalWaterLiters => _positive(goalWater, 3);
  double get goalStepsCount => _positive(goalSteps, 6000);
  double get goalSleepHours => _positive(goalSleep, 8);
  double get goalCalorieKcal => _positive(goalCalorie, 2000);

  Map<String, String> toJSON() {
    return {
      'uid': uid,
      'mobile': mobile,
      'name': name,
      'profileURL': profileURL,
      'gender': gender,
      'dob': dob,
      'height': height,
      'weight': weight,
      'age': age,
      'bmi': bmi,
      'goalWater': goalWater,
      'goalSteps': goalSteps,
      'goalSleep': goalSleep,
      'goalCalorie': goalCalorie,
    };
  }
}

UserModel userModelFromJSON(Map<String, dynamic> data) {
  return UserModel(
    data['uid'],
    data['mobile'],
    data['name'],
    data['profileURL'],
    data['gender'],
    data['dob'] ?? '',
    data['height'],
    data['weight'],
    data['age'],
    data['bmi'],
    data['goalWater'],
    data['goalSteps'],
    data['goalSleep'],
    data['goalCalorie'],
  );
}
