import 'package:flutter/material.dart';
import 'package:auth/constants/colors';

class MediaButtonsRow extends StatelessWidget {
  final VoidCallback onPickImage;
  final VoidCallback onPickVideo;

  const MediaButtonsRow({
    super.key,
    required this.onPickImage,
    required this.onPickVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onPickImage,
              icon: const Icon(Icons.image, color: AppColors.primary),
              label: const Text("Image", style: TextStyle(color: AppColors.primary)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onPickVideo,
              icon: const Icon(Icons.videocam, color: AppColors.primary),
              label: const Text("Video", style: TextStyle(color: AppColors.primary)),
            ),
          ),
        ],
      ),
    );
  }
}
