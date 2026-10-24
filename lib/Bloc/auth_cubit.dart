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
  error,
  loadFailed,
}

class AuthCubit extends Cubit<Authstate> {
  static GoogleSignIn? _googleSignInInstance;

  static Future<GoogleSignIn> get _googleSignIn async {
    if (_googleSignInInstance == null) {
      final instance = GoogleSignIn.instance;
      await instance.initialize(
        serverClientId: '1043018008926-tsetgd75rbo8dbaehhebdnos1l2btt1b.apps.googleusercontent.com',
      );
      _googleSignInInstance = instance;
    }
    return _googleSignInInstance!;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? error;
  User? user;

  late UserModel userModel;
  DataModel dataModel = DataModel('', 0, 0, 0, 0, 0);

  String? _verificationId;

  AuthCubit() : super(Authstate.init) {
    user = _auth.currentUser;
    if (user == null) {
      emit(Authstate.loggedOut);
    } else {
      _loadProfile(failureState: Authstate.loadFailed);
    }
  }

  void retry() {
    user = _auth.currentUser;
    if (user == null) {
      emit(Authstate.loggedOut);
    } else {
      emit(Authstate.init);
      _loadProfile(failureState: Authstate.loadFailed);
    }
  }

  Future<void> _loadProfile({Authstate failureState = Authstate.error}) async {
    try {
      final doc = await _firestore.collection('users').doc(user!.uid).get();
      if (doc.exists) {
        userModel = userModelFromJSON(doc.data()!);
        emit(Authstate.loggedIn);
      } else {
        emit(Authstate.unRegistered);
      }
    } catch (e) {
      error = e.toString();
      emit(failureState);
    }
  }

  Future<DataModel> getDataFromSQL() async {
    final result = await SQLHelper.getTodayData();
    return dataModelFromJson(result[0]);
  }

  void setDataModel(DataModel data) {
    dataModel = data;
  }

  void sendOTP(String phoneNumber) async {
    error = null;
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
      verificationFailed: (e) {
        error = e.message;
        emit(Authstate.error);
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void verifyOTP(String otp) async {
    final verificationId = _verificationId;
    if (verificationId == null) {
      error = 'Please request a new OTP';
      emit(Authstate.error);
      return;
    }
    error = null;
    emit(Authstate.loading);
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    signInWithPhone(credential);
  }

  Future<void> register(UserModel userModel) async {
    error = null;
    emit(Authstate.loading);
    try {
      this.userModel = userModel;
      await _firestore
          .collection('users')
          .doc(user!.uid)
          .set(userModel.toJSON());
      await _weightEntries(user!.uid)
          .doc(_todayKey())
          .set(
            WeightEntry(
              date: DateTime.now(),
              weight: double.parse(userModel.weight),
              height: double.parse(userModel.height),
              bmi: double.parse(userModel.bmi),
            ).toMap(),
          );
      emit(Authstate.loggedIn);
    } catch (e) {
      error = e.toString();
      emit(Authstate.error);
    }
  }

  String _todayKey() => DateFormat('yyyy-MM-dd').format(DateTime.now());

  CollectionReference<Map<String, dynamic>> _weightEntries(String uid) =>
      _firestore.collection('users').doc(uid).collection('weights');

  Stream<List<WeightEntry>> weightHistory() {
    return _weightEntries(userModel.uid)
        .orderBy('date')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => WeightEntry.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<void> saveBodyMetrics(double height, double weight) async {
    final bmi = calculateBmi(weight, height);
    final bmiText = bmi.toStringAsFixed(1);

    await _firestore.collection('users').doc(userModel.uid).update({
      'height': height.toString(),
      'weight': weight.toString(),
      'bmi': bmiText,
    });
    await _weightEntries(userModel.uid)
        .doc(_todayKey())
        .set(
          WeightEntry(
            date: DateTime.now(),
            weight: weight,
            height: height,
            bmi: double.parse(bmiText),
          ).toMap(),
        );

    userModel.height = height.toString();
    userModel.weight = weight.toString();
    userModel.bmi = bmiText;
  }

  Future<void> signInWithPhone(PhoneAuthCredential credential) async {
    try {
      user = (await _auth.signInWithCredential(credential)).user;
    } on FirebaseAuthException catch (e) {
      error = e.message ?? e.code;
      emit(Authstate.error);
      return;
    }

    if (user != null) await _loadProfile();
  }

  Future<void> signInWithGoogle() async {
    GoogleSignInAccount? googleUser;

    error = null;
    emit(Authstate.loading);
    try {
      final googleSignIn = await _googleSignIn;
      googleUser = await googleSignIn.authenticate(scopeHint: ['profile']);
    } catch (e) {
      debugPrint(e.toString());
      emit(Authstate.loggedOut);
      return;
    }

    final credential = GoogleAuthProvider.credential(
      idToken: googleUser.authentication.idToken,
    );

    try {
      user = (await _auth.signInWithCredential(credential)).user;
    } on FirebaseAuthException catch (e) {
      error = e.message ?? e.code;
      emit(Authstate.error);
      return;
    }

    if (user != null) await _loadProfile();
  }

  void logOut() async {
    await _auth.signOut();
    emit(Authstate.loggedOut);
  }

  Future<void> updateUserDetails(
    String name,
    String bmi,
    String watergoal,
    String stepgoal,
    String sleepgoal,
    String caloriegoal,
  ) async {
    await _firestore.collection('users').doc(userModel.uid).update({
      'name': name,
      'bmi': bmi,
      'goalWater': watergoal,
      'goalSteps': stepgoal,
      'goalSleep': sleepgoal,
      'goalCalorie': caloriegoal,
    });
    userModel.name = name;
    userModel.bmi = bmi;
    userModel.goalWater = watergoal;
    userModel.goalSteps = stepgoal;
    userModel.goalSleep = sleepgoal;
    userModel.goalCalorie = caloriegoal;
  }
}
