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
            const SizedBox(height: 25),
            SvgPicture.asset(
              'assets/images/lotus.svg',
              semanticsLabel: 'logo logo',
              colorFilter: const ColorFilter.mode(
                kPrimaryColor,
                BlendMode.srcIn,
              ),
              height: 240,
            ),
            const SizedBox(height: 120),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/meditation.gif',
                                  height: 150,
                                ),
                                Text(
                                  'Just Breath',
                                  style: kHeadingTextStyle.copyWith(
                                    fontSize: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      changeScreen(context, const JustBreath());
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/upset.png',
                                  height: 150,
                                ),
                                Text(
                                  'Relax Music',
                                  style: kHeadingTextStyle.copyWith(
                                    fontSize: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      changeScreen(context, const MusicPlayer());
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(width: 60),
            RoundedButton(
              title: 'Resources',
              colour: kPrimaryColor,
              onPressed: () {
                changeScreen(context, Resources());
              },
            ),
          ],
        ),
      ),
    );
  }
}
