import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swastha/Bloc/auth_cubit.dart';
import 'package:swastha/screens/home.dart';
import 'package:swastha/screens/side_drawer/weight_history.dart';
import 'package:swastha/services/change_screen.dart';
import 'package:swastha/utils/body_metrics.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/app_page.dart';
import 'package:swastha/widgets/body_metrics_input.dart';
import 'package:swastha/widgets/round_button.dart';

class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key});

  @override
  State<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  late final AuthCubit cubit = BlocProvider.of<AuthCubit>(context);
  late double height = cubit.userModel.heightCm.clamp(120, 220).toDouble();
  late double weight = cubit.userModel.weightKg.clamp(20, 200).toDouble();

  Future<void> save() async {
    showProgressDialog(context);
    try {
      await cubit.saveBodyMetrics(height, weight);
      if (!mounted) return;
      Navigator.pop(context);
      changeScreenClearStack(context, const Home());
    } catch (_) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save. Please try again.')),
      );
    }
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
                style: TextStyle(
                  color: kInk,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                bmi.toStringAsFixed(1),
                style: kHeadingTextStyle.copyWith(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w300,
                    fontSize: 48),
              ),
              Text(
                bmiCategory(bmi),
                style: kHeadingTextStyle.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 8),
              Text(
                bmiInterpretation(bmi),
                textAlign: TextAlign.center,
                style: kNormalTextStyle,
              ),
              RoundedButton(
                  title: 'Save to History',
                  colour: kPrimaryColor,
                  onPressed: () {
                    Navigator.pop(ctx);
                    save();
                  })
            ]),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = cubit.userModel;
    return AppPage(
      title: 'BMI Calculator',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              '${user.gender}, ${user.currentAge} years',
              textAlign: TextAlign.center,
              style: kSubHeadingTextStyle,
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: BodyMetricsInput(
              height: height,
              weight: weight,
              onHeightChanged: (value) => setState(() => height = value),
              onWeightChanged: (value) => setState(() => weight = value),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 2.0, horizontal: 64.0),
            child: RoundedButton(
                title: 'Calculate BMI',
                colour: kPrimaryColor,
                onPressed: showResult),
          ),
          TextButton.icon(
            onPressed: () => changeScreen(context, const WeightHistory()),
            icon: const Icon(Icons.show_chart),
            label: const Text('Weight & BMI History'),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
