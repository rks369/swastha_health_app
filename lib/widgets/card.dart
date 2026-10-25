import 'package:flutter/material.dart';
import 'package:swastha/utils/styles.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.colour,
    required this.cardChild,
    required this.onPress,
    this.borderColor = kBorder,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });
  final Color colour;
  final Widget cardChild;
  final Function()? onPress;
  final Color borderColor;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          color: colour,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(kRadius),
        ),
        child: cardChild,
      ),
    );
  }
}
