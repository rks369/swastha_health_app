import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swastha/Bloc/auth_cubit.dart';
import 'package:swastha/screens/home.dart';
import 'package:swastha/screens/side_drawer/weight_history.dart';
import 'package:swastha/services/change_screen.dart';
import 'package:swastha/utils/body_metrics.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/body_metrics_input.dart';
import 'package:swastha/widgets/round_button.dart';

class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key});

  @override
  State<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  late double height;
  late double weight;

  @override
  void initState() {
    super.initState();
    final user = BlocProvider.of<AuthCubit>(context).userModel;
    height = (double.tryParse(user.height) ?? 170).clamp(120, 220).toDouble();
    weight = (double.tryParse(user.weight) ?? 50).clamp(20, 200).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<AuthCubit>(context);
    final user = blocProvider.userModel;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
          backgroundColor: kWhite,
          mini: true,
          onPressed: (() {
            Navigator.pop(context);
          }),
          child: const Icon(
            Icons.arrow_back,
            color: kPrimaryColor,
          )),
      body: Container(
        decoration: const BoxDecoration(color: kPrimaryColor),
        child: SafeArea(
          child: Column(children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'BMI Calculator',
              style: TextStyle(
                  color: kWhite, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              '${user.gender}, ${user.currentAge} years',
              style: const TextStyle(color: kWhite),
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                    color: kGrey,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: BodyMetricsInput(
                        height: height,
                        weight: weight,
                        onHeightChanged: (value) =>
                            setState(() => height = value),
                        onWeightChanged: (value) =>
                            setState(() => weight = value),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 64.0),
                      child: RoundedButton(
                          title: 'Calculate BMI',
                          colour: kPrimaryColor,
                          onPressed: showResult),
                    ),
                    TextButton.icon(
                      onPressed: () =>
                          changeScreen(context, const WeightHistory()),
                      icon: const Icon(Icons.show_chart),
                      label: const Text('Weight & BMI History'),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void showResult() {
    final bmi = calculateBmi(weight, height);
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Center(
              child: Text(
                'Your BMI Is',
                style: kHeadingTextStyle,
              ),
            ),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                bmi.toStringAsFixed(1),
                style: kSubHeadingTextStyle.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 36),
              ),
              Text(
                bmiCategory(bmi),
                style: kHeadingTextStyle,
              ),
              Text(
                bmiInterpretation(bmi),
                textAlign: TextAlign.center,
                style: kNormalTextStyle,
              ),
              RoundedButton(
                  title: "Save to History",
                  colour: kPrimaryColor,
                  onPressed: () async {
                    showProgressDialog(context);
                    await BlocProvider.of<AuthCubit>(context)
                        .saveBodyMetrics(height, weight);
                    if (!context.mounted) return;
                    changeScreenReplacement(context, const Home());
                  })
            ]),
          );
        });
  }
}
