import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:swastha/Bloc/auth_cubit.dart';
import 'package:swastha/models/user_model.dart';
import 'package:swastha/screens/authentication/user_detail.dart';
import 'package:swastha/screens/home.dart';
import 'package:swastha/services/change_screen.dart';
import 'package:swastha/utils/body_metrics.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/app_page.dart';
import 'package:swastha/widgets/body_metrics_input.dart';
import 'package:swastha/widgets/round_button.dart';

class BMIReg extends StatefulWidget {
  final String name;
  final String profileURL;
  final DateTime dob;
  final String gender;
  const BMIReg({
    super.key,
    required this.name,
    required this.profileURL,
    required this.dob,
    required this.gender,
  });

  @override
  State<BMIReg> createState() => _BMIReg();
}

class _BMIReg extends State<BMIReg> {
  double weight = 50.0;
  double height = 170.0;

  late final int age = ageFromDob(widget.dob);
  double get bmi => calculateBmi(weight, height);

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'BMI Calculator',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              '${widget.gender}, $age years '
              '(${DateFormat('dd MMM yyyy').format(widget.dob)})',
              textAlign: TextAlign.center,
              style: kSubHeadingTextStyle,
            ),
          ),
          Expanded(
            child: BodyMetricsInput(
              height: height,
              weight: weight,
              onHeightChanged: (value) => setState(() => height = value),
              onWeightChanged: (value) => setState(() => weight = value),
            ),
          ),
          BlocConsumer<AuthCubit, Authstate>(
            listener: ((context, state) {
              if (state == Authstate.loggedIn) {
                changeScreenClearStack(context, const Home());
              } else if (state == Authstate.unRegistered) {
                changeScreenReplacement(context, const UserDetail());
              } else if (state == Authstate.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(BlocProvider.of<AuthCubit>(context).error ??
                        'Something went wrong. Please try again.'),
                  ),
                );
              }
            }),
            builder: ((context, state) {
              if (state == Authstate.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              return RoundedButton(
                title: "Finish",
                colour: kPrimaryColor,
                onPressed: () {
                  final auth = FirebaseAuth.instance.currentUser!;

                  BlocProvider.of<AuthCubit>(context).register(
                    UserModel(
                      auth.uid,
                      auth.phoneNumber ?? auth.email ?? '',
                      widget.name,
                      widget.profileURL,
                      widget.gender,
                      DateFormat('yyyy-MM-dd').format(widget.dob),
                      height.toString(),
                      weight.toString(),
                      age.toString(),
                      bmi.toStringAsFixed(1),
                      '3',
                      getGoalSteps(),
                      getGoalSleep(),
                      getGoalCalorie(),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  String getGoalSteps() {
    if (bmi >= 25) {
      return '9000';
    } else if (bmi > 18.5) {
      return '6000';
    } else {
      return '4000';
    }
  }

  String getGoalSleep() {
    if (age < 18) {
      return '9';
    } else if (age <= 30) {
      return '8';
    }
    return '7';
  }

  String getGoalCalorie() {
    if (widget.gender == 'Male') {
      if (age < 30) {
        return '2600';
      } else if (age <= 50) {
        return '2400';
      } else {
        return '2200';
      }
    } else {
      if (age < 30) return '2200';
      if (age <= 50) {
        return '2000';
      } else {
        return '1900';
      }
    }
  }
}
