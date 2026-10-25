import 'package:flutter/material.dart';
import 'package:swastha/utils/body_metrics.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/round_button.dart';

/// Shows a BMI result. Offers "Save to History" only when [onSave] is given.
Future<void> showBmiResult(
  BuildContext context, {
  required double bmi,
  required String gender,
  required int age,
  bool forSelf = true,
  VoidCallback? onSave,
}) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Center(
        child: Text(
          forSelf ? 'Your BMI Is' : 'BMI Is',
          style: const TextStyle(
            color: kInk,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$gender, $age years', style: kNormalTextStyle),
          Text(
            bmi.toStringAsFixed(1),
            style: kHeadingTextStyle.copyWith(
              color: kPrimaryColor,
              fontWeight: FontWeight.w300,
              fontSize: 48,
            ),
          ),
          Text(
            bmiCategory(bmi),
            style: kHeadingTextStyle.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 8),
          Text(
            bmiInterpretation(bmi, forSelf: forSelf),
            textAlign: TextAlign.center,
            style: kNormalTextStyle,
          ),
          if (age < 18) ...[
            const SizedBox(height: 8),
            const Text(
              'These ranges are for adults. For under 18, BMI should be '
              'read against age-based growth charts.',
              textAlign: TextAlign.center,
              style: kNormalTextStyle,
            ),
          ],
          RoundedButton(
            title: onSave != null ? 'Save to History' : 'Done',
            colour: kPrimaryColor,
            onPressed: () {
              Navigator.pop(ctx);
              onSave?.call();
            },
          ),
        ],
      ),
    ),
  );
}
