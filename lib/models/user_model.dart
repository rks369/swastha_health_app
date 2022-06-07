class UserModel {
  final String uid;
  final String mobile;
  final String name;
  final String profileURL;
  final String gender;
  final String height;
  final String weight;
  final String age;
  final String bmi;

  UserModel(this.uid, this.mobile, this.name, this.profileURL, this.gender,
      this.height, this.weight, this.age, this.bmi);

  Map<String, String> toJSON() {
    return {
      'uid': uid,
      'mobile': mobile,
      'name': name,
      'profileURL': profileURL,
      'gender': gender,
      'height': height,
      'weight': weight,
      'age': age,
      'bmi': bmi
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
      data['height'],
      data['weight'],
      data['age'],
      data['bmi']);
}
