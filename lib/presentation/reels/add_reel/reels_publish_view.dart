import 'dart:io';
import 'package:auth/presentation/reels/add_reel/widgets/publish_controls_overlay.dart';
import 'package:auth/presentation/reels/add_reel/widgets/reels_publish_view_app_bar.dart';
import 'package:auth/presentation/reels/add_reel/widgets/video_preview.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ReelsPublishView extends StatefulWidget {
  final XFile videoFile;
  const ReelsPublishView({super.key, required this.videoFile});

  @override
  State<ReelsPublishView> createState() => _ReelsPublishViewState();
}

class _ReelsPublishViewState extends State<ReelsPublishView> {
  late VideoPlayerController _controller;
  final TextEditingController _captionController = TextEditingController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    _controller = kIsWeb
        ? VideoPlayerController.networkUrl(Uri.parse(widget.videoFile.path))
        : VideoPlayerController.file(File(widget.videoFile.path));

    await _controller.initialize();

    _controller.setLooping(false);

    _controller.play();

    _controller.addListener(() {
      if (mounted) setState(() {});
    });

    setState(() => _isInitialized = true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: ReelsPublishViewAppBar(),
      body: Stack(
        children: [
          if (_isInitialized)
            VideoPreviewWidget(controller: _controller)
          else
            const Center(child: CircularProgressIndicator(color: Colors.white)),

          if (_isInitialized)
            PublishControlsOverlay(
              controller: _controller,
              captionController: _captionController,
            ),
        ],
      ),
    );
  }
}

