import 'package:flutter/material.dart';
import 'package:swastha/screens/home/mental_health/just_breath.dart';
import 'package:swastha/screens/home/mental_health/resources.dart';
import 'package:swastha/screens/home/mental_health/music_player.dart';
import 'package:swastha/utils/styles.dart';

class MentalHealth extends StatelessWidget {
  const MentalHealth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: kPrimaryColor),
      child: SafeArea(
          child: Column(children: [
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Mental health',
          style: TextStyle(
              color: kWhite, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
            child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              color: kGrey,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: MusicPlayer(),
        )),
      ])),
    );
  }
}
