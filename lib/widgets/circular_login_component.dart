import 'package:flutter/material.dart';
import 'package:swastha/utils/styles.dart';

class CircularLoginOption extends StatelessWidget {
  const CircularLoginOption({
    super.key,
    required this.icon,
    required this.onTap,
  });

  final Image icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: kBorder),
              image: DecorationImage(
                fit: BoxFit.scaleDown,
                scale: 1.6,
                image: icon.image,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
