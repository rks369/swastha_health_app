import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swastha/screens/home/mental_health/just_breath.dart';
import 'package:swastha/screens/home/mental_health/resources.dart';
import 'package:swastha/screens/home/mental_health/music_player.dart';
import 'package:swastha/services/change_screen.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/app_page.dart';
import 'package:swastha/widgets/round_button.dart';

class MentalHealth extends StatelessWidget {
  const MentalHealth({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Mental Health',
      showBack: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            SvgPicture.asset(
              'assets/images/lotus.svg',
              semanticsLabel: 'logo logo',
              colorFilter: const ColorFilter.mode(
                kPrimaryColor,
                BlendMode.srcIn,
              ),
              height: 200,
            ),
            const SizedBox(height: 64),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: _ActivityCard(
                      image: 'assets/images/meditation.gif',
                      label: 'Just Breath',
                      onTap: () => changeScreen(context, const JustBreath()),
                    ),
                  ),
                  Expanded(
                    child: _ActivityCard(
                      image: 'assets/images/upset.png',
                      label: 'Relax Music',
                      onTap: () => changeScreen(context, const MusicPlayer()),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            RoundedButton(
              title: 'Resources',
              colour: kPrimaryColor,
              onPressed: () {
                changeScreen(context, const Resources());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback onTap;

  const _ActivityCard({
    required this.image,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset(image, height: 120),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: kHeadingTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
