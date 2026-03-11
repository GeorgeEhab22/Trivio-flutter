import 'package:flutter/material.dart';
class VideoMuteButton extends StatelessWidget {
  final bool isMuted;
  final VoidCallback onTap;

  const VideoMuteButton({
    super.key,
    required this.isMuted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
          color: Colors.black,
          size: 20,
        ),
      ),
    );
  }
}