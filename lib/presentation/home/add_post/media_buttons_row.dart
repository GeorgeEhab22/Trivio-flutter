import 'package:auth/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:auth/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    const iconColor = AppColors.primary;

    final buttonStyle = OutlinedButton.styleFrom(
      side: const BorderSide(color: AppColors.primary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              style: buttonStyle,
              onPressed: onPickImage,
              icon: const Icon(Icons.image, color: iconColor),
              label: Text(
                l10n.image, // Localized
                style: const TextStyle(color: iconColor),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              style: buttonStyle,
              onPressed: onPickVideo,
              icon: const Icon(Icons.videocam, color: iconColor),
              label: Text(
                l10n.video, // Localized
                style: const TextStyle(color: iconColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}