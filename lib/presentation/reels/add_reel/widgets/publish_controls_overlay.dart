import 'package:auth/constants/colors.dart';
import 'package:auth/presentation/reels/add_reel/widgets/add_caption_field.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PublishControlsOverlay extends StatelessWidget {
  final VideoPlayerController controller;
  final TextEditingController captionController;

  const PublishControlsOverlay({
    super.key,
    required this.controller,
    required this.captionController,
  });

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      bottom: keyboardHeight > 0 ? keyboardHeight + 15 : 40,
      left: 15,
      right: 15,
      child: ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, VideoPlayerValue value, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    Text(
                      "${_formatDuration(value.position)} / ${_formatDuration(value.duration)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 5,
                  ),
                ),
                child: Slider(
                  value: value.position.inMilliseconds.toDouble(),
                  min: 0.0,
                  max: value.duration.inMilliseconds.toDouble(),
                  activeColor: AppColors.primary,
                  onChanged: (val) =>
                      controller.seekTo(Duration(milliseconds: val.toInt())),
                ),
              ),
              const SizedBox(height: 5),
              AddCaptionField(controller: captionController),
            ],
          );
        },
      ),
    );
  }
}
