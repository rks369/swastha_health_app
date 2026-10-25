import 'package:flutter/material.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/card.dart';
import 'package:swastha/widgets/circle_button.dart';

/// Card with a whole-number value and − / + buttons.
class StepperCard extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const StepperCard({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return UserCard(
      colour: kWhite,
      onPress: null,
      cardChild: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(label, style: kCardLabelStyle),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleButton(
                  icon: Icons.remove,
                  onpressed: value > min ? () => onChanged(value - 1) : null,
                ),
                SizedBox(
                  width: 120,
                  child: Text(
                    '$value',
                    textAlign: TextAlign.center,
                    style: kCardValueStyle,
                  ),
                ),
                CircleButton(
                  icon: Icons.add,
                  onpressed: value < max ? () => onChanged(value + 1) : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
