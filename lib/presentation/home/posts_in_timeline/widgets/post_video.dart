import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostVideo extends StatefulWidget {
  final String videoUrl;
  final Function(Duration)? onPositionChanged;

  const PostVideo({super.key, required this.videoUrl, this.onPositionChanged});

  @override
  State<PostVideo> createState() => _PostVideoState();
}

class _PostVideoState extends State<PostVideo> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isMuted = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          _controller.setLooping(true);
          _controller.setVolume(_isMuted ? 0 : 1);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: (visibilityInfo) {
        if (!mounted || !_isInitialized) return;

        if (visibilityInfo.visibleFraction > 0.8) {
          _controller.play();
        } else {
          _controller.pause();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: ClipRRect(
          // borderRadius: BorderRadius.circular(16),
          child: Container(
            color: Colors.black,
            child: _isInitialized
                ? Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                      _buildMuteButton(),
                    ],
                  )
                : const SizedBox(
                    height: 250,
                    child: Center(child: CircularProgressIndicator()),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildMuteButton() {
    return Positioned(
      bottom: 10,
      right: 10,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isMuted = !_isMuted;
            _controller.setVolume(_isMuted ? 0 : 1);
          });
        },
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 127),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _isMuted ? Icons.volume_off : Icons.volume_up,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
