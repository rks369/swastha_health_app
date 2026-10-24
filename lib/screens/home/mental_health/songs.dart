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
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Card(
            color: selected ? kActiveSelect.withValues(alpha: 0.15) : null,
            child: ListTile(
              contentPadding: const EdgeInsets.all(8),
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: kPrimaryColor.withValues(alpha: 0.15),
                foregroundImage: NetworkImage(song.cover),
                onForegroundImageError: (_, _) {},
                child: const Icon(Icons.music_note, color: kPrimaryColor),
              ),
              title: Text(song.title, style: kSubHeadingTextStyle),
              subtitle: Text(song.duration),
              trailing: IconButton(
                tooltip: selected && isPlaying ? 'Pause' : 'Play',
                iconSize: 40,
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
