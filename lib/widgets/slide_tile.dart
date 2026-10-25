import 'package:flutter/material.dart';
import 'package:swastha/utils/styles.dart';

class SlideTile extends StatelessWidget {
  const SlideTile({
    super.key,
    required this.imageAssetPath,
    required this.title,
    required this.description,
  });
  final String imageAssetPath;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/logo.png', width: 72, height: 72),
        const SizedBox(height: 20),
        Text(title, textAlign: TextAlign.center, style: kHeadingTextStyle),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: kSubHeadingTextStyle,
          ),
        ),
        const SizedBox(height: 24),
        Image.asset(imageAssetPath, height: 320),
      ],
    );
  }
}
