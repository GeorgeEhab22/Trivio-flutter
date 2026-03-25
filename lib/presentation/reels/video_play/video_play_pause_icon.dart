import 'package:flutter/material.dart';

class VideoPlayPauseIcon extends StatelessWidget {
  final bool isPlaying;

  const VideoPlayPauseIcon({super.key, required this.isPlaying});

  @override
  Widget build(BuildContext context) {
    if (isPlaying) return const SizedBox.shrink();

    return const IgnorePointer(
      child: Icon(Icons.play_arrow_rounded, size: 90, color: Colors.white54),
    );
  }
}
