import 'package:flutter/material.dart';
import 'package:swastha/utils/styles.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.colour,
    required this.cardChild,
    required this.onPress,
  });
  final Color colour;
  final Widget cardChild;
  final Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: colour,
          border: Border.all(color: kBorder),
          borderRadius: BorderRadius.circular(kRadius),
        ),
        child: cardChild,
      ),
    );
  }
}
