import 'package:flutter/material.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/card.dart';
import 'package:swastha/widgets/circle_button.dart';

class BodyMetricsInput extends StatelessWidget {
  final double height;
  final double weight;
  final ValueChanged<double> onHeightChanged;
  final ValueChanged<double> onWeightChanged;

  const BodyMetricsInput({
    super.key,
    required this.height,
    required this.weight,
    required this.onHeightChanged,
    required this.onWeightChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: UserCard(
            colour: kWhite,
            onPress: null,
            cardChild: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Height (cm)', style: kCardLabelStyle),
                Text(height.round().toString(), style: kCardValueStyle),
                Slider(
                  value: height,
                  min: 120.0,
                  max: 220.0,
                  divisions: 100,
                  onChanged: (value) => onHeightChanged(value.roundToDouble()),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: UserCard(
            colour: kWhite,
            onPress: null,
            cardChild: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Weight (kg)', style: kCardLabelStyle),
                Text(weight.toStringAsFixed(1), style: kCardValueStyle),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleButton(
                      icon: Icons.remove,
                      onpressed: () => onWeightChanged(_round(weight - 0.1)),
                    ),
                    Expanded(
                      child: Slider(
                        value: weight,
                        min: 20.0,
                        max: 200.0,
                        onChanged: (value) => onWeightChanged(_round(value)),
                      ),
                    ),
                    CircleButton(
                      icon: Icons.add,
                      onpressed: () => onWeightChanged(_round(weight + 0.1)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  double _round(double value) {
    return (value.clamp(20.0, 200.0) * 10).round() / 10;
  }
}
