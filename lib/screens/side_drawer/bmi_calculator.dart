import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swastha/Bloc/auth_cubit.dart';
import 'package:swastha/screens/home.dart';
import 'package:swastha/screens/side_drawer/weight_history.dart';
import 'package:swastha/services/change_screen.dart';
import 'package:swastha/utils/body_metrics.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/app_page.dart';
import 'package:swastha/widgets/bmi_result_dialog.dart';
import 'package:swastha/widgets/body_metrics_input.dart';
import 'package:swastha/widgets/gender_selector.dart';
import 'package:swastha/widgets/round_button.dart';
import 'package:swastha/widgets/stepper_card.dart';

enum _Subject { self, other }

class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key});

  @override
  State<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  late final AuthCubit cubit = BlocProvider.of<AuthCubit>(context);

  _Subject subject = _Subject.self;
  late double myHeight = cubit.userModel.heightCm.clamp(120, 220).toDouble();
  late double myWeight = cubit.userModel.weightKg.clamp(20, 200).toDouble();
  double otherHeight = 170;
  double otherWeight = 65;
  int otherAge = 30;
  String? otherGender;

  bool get isSelf => subject == _Subject.self;
  double get height => isSelf ? myHeight : otherHeight;
  double get weight => isSelf ? myWeight : otherWeight;

  void setHeight(double value) =>
      setState(() => isSelf ? myHeight = value : otherHeight = value);

  void setWeight(double value) =>
      setState(() => isSelf ? myWeight = value : otherWeight = value);

  Future<void> save() async {
    showProgressDialog(context);
    try {
      await cubit.saveBodyMetrics(myHeight, myWeight);
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

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void calculate() {
    final bmi = calculateBmi(weight, height);
    if (isSelf) {
      final user = cubit.userModel;
      showBmiResult(
        context,
        bmi: bmi,
        gender: user.gender,
        age: user.currentAge,
        onSave: save,
      );
      return;
    }

    if (otherGender == null) return showError('Please select a gender');
    showBmiResult(
      context,
      bmi: bmi,
      gender: otherGender!,
      age: otherAge,
      forSelf: false,
    );
  }

  Widget subjectToggle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: SizedBox(
        width: double.infinity,
        child: SegmentedButton<_Subject>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(
              value: _Subject.self,
              icon: Icon(Icons.person_outline),
              label: Text('Myself'),
            ),
            ButtonSegment(
              value: _Subject.other,
              icon: Icon(Icons.people_outline),
              label: Text('Someone else'),
            ),
          ],
          selected: {subject},
          onSelectionChanged: (value) =>
              setState(() => subject = value.first),
        ),
      ),
    );
  }

  Widget selfSummary() {
    final user = cubit.userModel;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        '${user.gender}, ${user.currentAge} years',
        textAlign: TextAlign.center,
        style: kSubHeadingTextStyle,
      ),
    );
  }

  Widget metricsInput({double? fixedHeight}) {
    final input = BodyMetricsInput(
      height: height,
      weight: weight,
      onHeightChanged: setHeight,
      onWeightChanged: setWeight,
    );
    return fixedHeight == null
        ? input
        : SizedBox(height: fixedHeight, child: input);
  }

  Widget otherInputs() {
    return SingleChildScrollView(
      child: Column(
        children: [
          GenderSelector(
            selected: otherGender,
            onChanged: (value) => setState(() => otherGender = value),
          ),
          StepperCard(
            label: 'Age (years)',
            value: otherAge,
            min: 1,
            max: 120,
            onChanged: (value) => setState(() => otherAge = value),
          ),
          metricsInput(fixedHeight: 400),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'BMI Calculator',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          subjectToggle(),
          Expanded(
            child: isSelf
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      selfSummary(),
                      const SizedBox(height: 4),
                      Expanded(child: metricsInput()),
                    ],
                  )
                : otherInputs(),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 2.0, horizontal: 64.0),
            child: RoundedButton(
              title: 'Calculate BMI',
              colour: kPrimaryColor,
              onPressed: calculate,
            ),
          ),
          if (isSelf)
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
