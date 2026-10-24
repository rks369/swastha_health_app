import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:swastha/database/sql_helper.dart';
import 'package:swastha/models/data_model.dart';
import 'package:swastha/models/user_model.dart';
import 'package:swastha/models/weight_entry.dart';
import 'package:swastha/models/water_model.dart';
import 'package:swastha/utils/body_metrics.dart';

enum Authstate {
  init,
  loading,
  otpSend,
  otpVerified,
  registered,
  unRegistered,
  loggedIn,
  loggedOut,
  error
}

class AuthCubit extends Cubit<Authstate> {

  static GoogleSignIn? __googleSignIn;
  static Future<GoogleSignIn> get _googleSignIn async {

    if(__googleSignIn == null) {
      __googleSignIn = GoogleSignIn.instance;
      await __googleSignIn?.initialize(
        serverClientId:
            '1043018008926-tsetgd75rbo8dbaehhebdnos1l2btt1b.apps.googleusercontent.com',
      );
    }

    assert(__googleSignIn != null ,"Google Sign In Can't be Null");

    return __googleSignIn!;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? error;
  User? user;

  late UserModel userModel;
  DataModel dataModel = DataModel('', 0, 0, 0, 0, 0);

  WaterModel waterModel = WaterModel(0.0, 0.0);

  AuthCubit() : super(Authstate.init) {
    user = _auth.currentUser;
    if (user != null) {
      _firestore.collection('users').doc(user!.uid).get().then((value) {
        if (value.exists) {
          final data = value.data();

          userModel = userModelFromJSON(data!);

          emit(Authstate.loggedIn);
        } else {
          emit(Authstate.unRegistered);
        }
      });
    } else {
      emit(Authstate.loggedOut);
    }
  }

  Future<DataModel> getDataFromSQL() async {
    final result = await SQLHelper.getTodayData();
    return dataModelFromJson(result[0]);
  }

  void setDataModel(DataModel data) {
    dataModel = data;
  }

  String? _verificationId;

  void sendOTP(String phoneNumber) async {
    emit(Authstate.loading);
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeSent: (verificationId, forceResendingToken) {
        _verificationId = verificationId;
        emit(Authstate.otpSend);
      },
      verificationCompleted: (phoneAuthCredential) {
        signInWithPhone(phoneAuthCredential);
      },
      verificationFailed: (error) {
        emit(Authstate.error);
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void verifyOTP(String otp) async {
    emit(Authstate.loading);
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!, smsCode: otp);

    signInWithPhone(credential);
  }

  void register(UserModel userModel) async {
    this.userModel = userModel;
    await _firestore
        .collection('users')
        .doc(user!.uid)
        .set(userModel.toJSON());
    await _weightEntries(user!.uid).doc(_todayKey()).set(WeightEntry(
          date: DateTime.now(),
          weight: double.parse(userModel.weight),
          height: double.parse(userModel.height),
          bmi: double.parse(userModel.bmi),
        ).toMap());
    emit(Authstate.loggedIn);
  }

  String _todayKey() => DateFormat('yyyy-MM-dd').format(DateTime.now());

  CollectionReference<Map<String, dynamic>> _weightEntries(String uid) =>
      _firestore.collection('users').doc(uid).collection('weights');

  Stream<List<WeightEntry>> weightHistory() {
    return _weightEntries(userModel.uid)
        .orderBy('date')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WeightEntry.fromMap(doc.data()))
            .toList());
  }

  Future<void> saveBodyMetrics(double height, double weight) async {
    final bmi = calculateBmi(weight, height);
    final bmiText = bmi.toStringAsFixed(1);

    await _firestore.collection('users').doc(userModel.uid).update({
      'height': height.toString(),
      'weight': weight.toString(),
      'bmi': bmiText,
    });
    await _weightEntries(userModel.uid).doc(_todayKey()).set(WeightEntry(
          date: DateTime.now(),
          weight: weight,
          height: height,
          bmi: double.parse(bmiText),
        ).toMap());

    userModel.height = height.toString();
    userModel.weight = weight.toString();
    userModel.bmi = bmiText;
  }

  void signInWithPhone(PhoneAuthCredential credential) async {
    try {
      user = await _auth
          .signInWithCredential(credential)
          .then((value) => value.user);

      if (user != null) {
        _firestore.collection('users').doc(user!.uid).get().then((value) {
          if (value.exists) {
            final data = value.data();

            userModel = userModelFromJSON(data!);
            emit(Authstate.loggedIn);
          } else {
            emit(Authstate.unRegistered);
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      error = e.toString();
    }
  }

  void signInWithGoogle() async {

    GoogleSignInAccount? googleUser;

    final GoogleSignIn googleSignIn = await _googleSignIn;

    try {
      googleUser = await googleSignIn.authenticate(
          scopeHint: ['profile']
      );
    } catch(error) {
      debugPrint(error.toString());
    }

    if(googleUser != null) {
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );


      try {
        user = await _auth
            .signInWithCredential(credential)
            .then((value) => value.user);

        if (user != null) {
          _firestore.collection('users').doc(user!.uid).get().then((value) {
            if (value.exists) {
              final data = value.data();

              userModel = userModelFromJSON(data!);
              emit(Authstate.loggedIn);
            } else {
              emit(Authstate.unRegistered);
            }
          });
        }
      } on FirebaseAuthException catch (e) {
        error = e.toString();
      }

    }

  }

  void logOut() async {
    await _auth.signOut();
    emit(Authstate.loggedOut);
  }

  void setWaterGoal(double goal) {
    waterModel.goalwater = goal;
  }

  void setWaterTaken(double taken) {
    dataModel.water = int.parse(taken.toString());
  }

  void updateUserDetails(String name, String bmi, String watergoal,
      String stepgoal, String sleepgoal, String caloriegoal) {
    userModel.name = name;
    userModel.bmi = bmi;
    userModel.goalWater = watergoal;
    userModel.goalSteps = stepgoal;
    userModel.goalSleep = sleepgoal;
    userModel.goalCalorie = caloriegoal;
  }
}
