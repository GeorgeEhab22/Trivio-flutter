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
    _initVideoControllersFor(widget.files);
  }

  @override
  void didUpdateWidget(covariant SelectedMediaPreview oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldPaths = oldWidget.files.map((f) => f.path).toSet();
    final newPaths = widget.files.map((f) => f.path).toSet();

    final removed = oldPaths.difference(newPaths);
    for (final path in removed) {
      final c = _controllers.remove(path);
      c?.dispose();
    }

    final added = newPaths.difference(oldPaths);
    if (added.isNotEmpty) {
      final addedFiles =
          widget.files.where((f) => added.contains(f.path)).toList();
      _initVideoControllersFor(addedFiles);
    }
  }

  @override
  void dispose() {
    for (var c in _controllers.values) {
      try {
        c.dispose();
      } catch (_) {}
    }
    _controllers.clear();
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


  void _initVideoControllersFor(List<XFile> files) {
    for (var file in files) {
      if (!_isVideo(file)) continue;
      if (_controllers.containsKey(file.path)) continue; 

      late final VideoPlayerController controller;
      if (kIsWeb) {
        controller = VideoPlayerController.networkUrl(Uri.parse(file.path));
      } else {
        controller = VideoPlayerController.file(File(file.path));
      }

      controller.setLooping(true);
      controller.setVolume(0);

      final initializeFuture = controller.initialize();

      initializeFuture.then((_) {
        if (!mounted) {
          try {
            controller.dispose();
          } catch (_) {}
          return;
        }
        final existing = _controllers[file.path];
        if (existing != null && existing != controller) {
          try {
            controller.dispose();
          } catch (_) {}
          return;
        }

        _controllers[file.path] = controller;
        if (mounted) setState(() {});
      }).catchError((err) {
        try {
          controller.dispose();
        } catch (_) {}
      });
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
              aspectRatio: controller != null && controller.value.isInitialized
                  ? controller.value.aspectRatio
                  : 16 / 9,
              child: controller != null && controller.value.isInitialized
                  ? _VideoPreviewDialog(controller: controller)
                  : const Center(child: CircularProgressIndicator()),
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
              // Placeholder while video controller initializes
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


class _VideoPreviewDialog extends StatefulWidget {
  final VideoPlayerController controller;
  const _VideoPreviewDialog({required this.controller});

  @override
  State<_VideoPreviewDialog> createState() => _VideoPreviewDialogState();
}

class _VideoPreviewDialogState extends State<_VideoPreviewDialog> {
  late VideoPlayerController _controller;
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _listener = () {
      if (mounted) setState(() {});
    };
    _controller.addListener(_listener);
  }

  @override
  void dispose() {
    try {
      _controller.removeListener(_listener);
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = _controller.value.isPlaying;
    return Stack(
      children: [
        VideoPlayer(_controller),
        Align(
          alignment: Alignment.center,
          child: IconButton(
            icon: Icon(
              isPlaying ? Icons.pause_circle : Icons.play_circle,
              color: Colors.white70,
              size: 60,
            ),
            onPressed: () {
              if (isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
              // controller listener will call setState to update icon
            },
          ),
        ),
      ],
    );
  }
}
