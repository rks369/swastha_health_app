import 'package:flutter/material.dart';
import 'package:swastha/models/audio_model.dart';
import 'package:swastha/utils/styles.dart';

class SongWidget extends StatelessWidget {
  final int? currentIndex;
  final bool isPlaying;
  final ValueChanged<int> onSelect;

  const SongWidget({
    super.key,
    required this.currentIndex,
    required this.isPlaying,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: songList.length,
      itemBuilder: (context, index) {
        final song = songList[index];
        final selected = index == currentIndex;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          child: Card(
            margin: EdgeInsets.zero,
            color: selected ? kPrimaryColor.withValues(alpha: 0.06) : null,
            child: ListTile(
              contentPadding: const EdgeInsets.all(8),
              leading: CircleAvatar(
                radius: 26,
                backgroundColor: kPrimaryColor.withValues(alpha: 0.15),
                foregroundImage: NetworkImage(song.cover),
                onForegroundImageError: (_, _) {},
                child: const Icon(Icons.music_note, color: kPrimaryColor),
              ),
              title: Text(
                song.title,
                style: const TextStyle(
                  color: kInk,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(song.duration, style: kNormalTextStyle),
              trailing: IconButton(
                tooltip: selected && isPlaying ? 'Pause' : 'Play',
                iconSize: 36,
                color: kPrimaryColor,
                icon: Icon(selected && isPlaying
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_outline),
                onPressed: () => onSelect(index),
              ),
            ),
          ),
        );
      },
    );
  }
}
