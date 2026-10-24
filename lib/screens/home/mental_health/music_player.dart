import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:swastha/models/audio_model.dart';
import 'package:swastha/screens/home/mental_health/songs.dart';
import 'package:swastha/utils/styles.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayer();
}

class _MusicPlayer extends State<MusicPlayer> {
  final AudioPlayer player = AudioPlayer();
  final List<StreamSubscription<dynamic>> subscriptions = [];

  int? current;
  bool isPlaying = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    subscriptions.addAll([
      player.onPlayerStateChanged.listen((state) {
        setState(() => isPlaying = state == PlayerState.playing);
      }),
      player.onPositionChanged.listen((value) {
        setState(() => position = value);
      }),
      player.onDurationChanged.listen((value) {
        setState(() => duration = value);
      }),
      player.onPlayerComplete.listen((_) => skip(1)),
    ]);
  }

  @override
  void dispose() {
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
    player.dispose();
    super.dispose();
  }

  Future<void> play(int index) async {
    setState(() {
      current = index;
      position = Duration.zero;
      duration = Duration.zero;
    });
    // AssetSource already prefixes the "assets/" folder.
    final path = songList[index].audioPath.replaceFirst('assets/', '');
    await player.play(AssetSource(path));
  }

  Future<void> select(int index) async {
    if (index == current) {
      await togglePlay();
    } else {
      await play(index);
    }
  }

  Future<void> togglePlay() async {
    if (current == null) return play(0);
    if (isPlaying) {
      await player.pause();
    } else {
      await player.resume();
    }
  }

  Future<void> skip(int step) async {
    final next = ((current ?? -1) + step) % songList.length;
    await play(next);
  }

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        foregroundColor: kWhite,
        title: const Text('Relaxing Music Player'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SongWidget(
              currentIndex: current,
              isPlaying: isPlaying,
              onSelect: select,
            ),
          ),
          bottomPanel(),
        ],
      ),
    );
  }

  Widget songProgress() {
    const style = TextStyle(color: kPrimaryColor);
    final total = duration.inMilliseconds;
    final value = total == 0
        ? 0.0
        : (position.inMilliseconds / total).clamp(0.0, 1.0).toDouble();
    return Row(
      children: <Widget>[
        Text(formatDuration(position), style: style),
        Expanded(
          child: Slider(
            activeColor: kPrimaryColor,
            inactiveColor: kActiveSelect,
            value: value,
            onChanged: total == 0
                ? null
                : (v) => player.seek(Duration(milliseconds: (total * v).round())),
          ),
        ),
        Text(formatDuration(duration), style: style),
      ],
    );
  }

  Widget bottomPanel() {
    return SafeArea(
      top: false,
      child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: songProgress(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircleAvatar(
                radius: 25,
                backgroundColor: kActiveSelect,
                child: IconButton(
                  tooltip: 'Previous',
                  icon: const Icon(Icons.skip_previous, color: kWhite),
                  onPressed: () => skip(-1),
                ),
              ),
              CircleAvatar(
                backgroundColor: kPrimaryColor,
                radius: 30,
                child: IconButton(
                  tooltip: isPlaying ? 'Pause' : 'Play',
                  onPressed: togglePlay,
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: kWhite,
                  ),
                ),
              ),
              CircleAvatar(
                radius: 25,
                backgroundColor: kActiveSelect,
                child: IconButton(
                  tooltip: 'Next',
                  icon: const Icon(Icons.skip_next, color: kWhite),
                  onPressed: () => skip(1),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
