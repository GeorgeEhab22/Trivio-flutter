import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  const VideoPlayerWidget({super.key, required this.url});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  int _loopCount = 0;
  final int _maxLoops = 3;
  bool _isUserPaused = false;
  bool _isFinished = false;
  bool _isVisible = true;
  Duration _lastPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _isInitialized = true);
          _controller.setLooping(true);
          _controller.addListener(_videoListener);

          if (_isVisible && !_isUserPaused) {
            _controller.play();
          }
        }
      });
  }

  void _videoListener() {
    if (!_isInitialized || !_controller.value.isPlaying) return;

    final position = _controller.value.position;
    final duration = _controller.value.duration;

    if (duration == Duration.zero) return;

    if (position < _lastPosition &&
        _lastPosition.inMilliseconds > duration.inMilliseconds - 500) {
      _loopCount++;

      if (_loopCount >= _maxLoops) {
        _isFinished = true;
        _controller.pause();
        _controller.setLooping(false);
        _controller.seekTo(duration);
        if (mounted) setState(() {});
      }
    }
    _lastPosition = position;
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (!_isInitialized) return;

    if (_controller.value.isPlaying) {
      _controller.pause();
      _isUserPaused = true;
    } else {
      _isUserPaused = false;
      if (_isFinished ||
          _controller.value.position >= _controller.value.duration) {
        _loopCount = 0;
        _isFinished = false;
        _controller.setLooping(true);
        _controller.seekTo(Duration.zero);
      }
      _controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.url),
      onVisibilityChanged: (visibilityInfo) {
        _isVisible = visibilityInfo.visibleFraction > 0.8;

        if (!_isInitialized) return;

        if (visibilityInfo.visibleFraction == 0 && mounted) {
          _controller.pause();
        } else if (_isVisible && mounted && !_isUserPaused && !_isFinished) {
          _controller.play();
        }
      },
      child: Container(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Center(
              child: _isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : const CircularProgressIndicator(color: Colors.white),
            ),

            if (_isInitialized)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 30,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _togglePlayPause,
                  child: const SizedBox.expand(),
                ),
              ),

            if (_isInitialized)
              IgnorePointer(
                child: Center(
                  child: ValueListenableBuilder(
                    valueListenable: _controller,
                    builder: (context, VideoPlayerValue value, child) {
                      return AnimatedOpacity(
                        opacity: value.isPlaying ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 90,
                          shadows: [
                            Shadow(blurRadius: 10, color: Colors.black54),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

            if (_isInitialized)
              VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                colors: VideoProgressColors(
                  playedColor: Colors.white,
                  bufferedColor: Colors.white.withValues(alpha: 0.4),
                  backgroundColor: Colors.white.withValues(alpha: 0.15),
                ),
              ),

            if (_isInitialized)
              Positioned(
                bottom: 14,
                left: 16,
                child: IgnorePointer(
                  child: ValueListenableBuilder(
                    valueListenable: _controller,
                    builder: (context, VideoPlayerValue value, child) {
                      return Text(
                        "${_formatDuration(value.position)} / ${_formatDuration(value.duration)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          shadows: [
                            Shadow(blurRadius: 10, color: Colors.black),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
