import 'package:flutter/material.dart';
import 'package:swastha/utils/styles.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({super.key, required this.icon, required this.onpressed});
  final IconData icon;
  final VoidCallback? onpressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 0.0,
      highlightElevation: 0.0,
      onPressed: onpressed,
      constraints: const BoxConstraints.tightFor(width: 44.0, height: 44.0),
      shape: const CircleBorder(),
      fillColor: kPrimaryColor.withValues(alpha: 0.1),
      child: Icon(icon, color: kPrimaryColor, size: 20),
    );
  }
}
