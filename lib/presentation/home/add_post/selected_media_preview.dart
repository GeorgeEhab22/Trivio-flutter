import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class SelectedMediaPreview extends StatefulWidget {
  final List<XFile> files;
  final Function(int) onRemove;

  const SelectedMediaPreview({
    super.key,
    required this.files,
    required this.onRemove,
  });

  @override
  State<SelectedMediaPreview> createState() => _SelectedMediaPreviewState();
}

class _SelectedMediaPreviewState extends State<SelectedMediaPreview> {
  final Map<String, VideoPlayerController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _initVideoControllers();
  }

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  bool _isVideo(XFile file) {
    final mime = file.mimeType ?? '';
    final ext = file.path.toLowerCase();
    return mime.startsWith('video/') ||
        ext.endsWith('.mp4') ||
        ext.endsWith('.mov') ||
        ext.endsWith('.avi') ||
        ext.endsWith('.webm');
  }

  Future<void> _initVideoControllers() async {
    for (var file in widget.files) {
      if (_isVideo(file)) {
        late VideoPlayerController controller;
        if (kIsWeb) {
          controller = VideoPlayerController.networkUrl(Uri.parse(file.path));
        } else {
          controller = VideoPlayerController.file(File(file.path));
        }
        await controller.initialize();
        controller.setLooping(true);
        controller.setVolume(0);
        setState(() {
          _controllers[file.path] = controller;
        });
      }
    }
  }

  void _showPreviewDialog(XFile file) {
    final isVideo = _isVideo(file);

    showDialog(
      context: context,
      builder: (context) {
        if (isVideo) {
          final controller = _controllers[file.path];
          return Dialog(
            insetPadding: const EdgeInsets.all(16),
            child: AspectRatio(
              aspectRatio:
                  controller != null && controller.value.isInitialized
                      ? controller.value.aspectRatio
                      : 16 / 9,
              child: controller != null && controller.value.isInitialized
                  ? Stack(
                      children: [
                        VideoPlayer(controller),
                        Align(
                          alignment: Alignment.center,
                          child: IconButton(
                            icon: Icon(
                              controller.value.isPlaying
                                  ? Icons.pause_circle
                                  : Icons.play_circle,
                              color: Colors.white70,
                              size: 60,
                            ),
                            onPressed: () {
                              setState(() {
                                controller.value.isPlaying
                                    ? controller.pause()
                                    : controller.play();
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          );
        } else {
          return Dialog(
            insetPadding: const EdgeInsets.all(16),
            child: kIsWeb
                ? Image.network(file.path, fit: BoxFit.contain)
                : Image.file(File(file.path), fit: BoxFit.contain),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(widget.files.length, (index) {
          final file = widget.files[index];
          final isVideo = _isVideo(file);
          final controller = _controllers[file.path];

          Widget mediaWidget;

          if (isVideo) {
            if (controller != null && controller.value.isInitialized) {
              mediaWidget = ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: VideoPlayer(controller),
                    ),
                    const Icon(Icons.play_circle_fill,
                        color: Colors.white70, size: 32),
                  ],
                ),
              );
            } else {
              mediaWidget = Container(
                width: 100,
                height: 100,
                color: Colors.black12,
                child: const Center(
                  child: Icon(Icons.videocam, color: Colors.grey, size: 40),
                ),
              );
            }
          } else {
            mediaWidget = kIsWeb
                ? Image.network(file.path,
                    width: 100, height: 100, fit: BoxFit.cover)
                : Image.file(File(file.path),
                    width: 100, height: 100, fit: BoxFit.cover);
          }
          return Stack(
            children: [
              GestureDetector(
                onTap: () => _showPreviewDialog(file),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(width: 100, height: 100, child: mediaWidget),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => widget.onRemove(index),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black54,
                    ),
                    padding: const EdgeInsets.all(4),
                    child:
                        const Icon(Icons.close, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
