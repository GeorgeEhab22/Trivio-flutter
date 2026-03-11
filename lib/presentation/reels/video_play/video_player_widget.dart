import 'package:auth/presentation/reels/video_play/video_gesture_overlay.dart';
import 'package:auth/presentation/reels/video_play/video_mute_button.dart';
import 'package:auth/presentation/reels/video_play/video_play_pause_icon.dart';
import 'package:auth/presentation/reels/video_play/video_timer_and_speed_overlay.dart';
import 'package:flutter/material.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  final CachedVideoPlayerPlus? cachedPlayer;

  const VideoPlayerWidget({super.key, required this.url, this.cachedPlayer});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  int _loopCount = 0;
  final int _maxLoops = 3;
  bool _isFinished = false;
  bool _isMuted = false;
  bool _isVisible = false;
  bool _isUserPaused = false; 
  Duration _lastPosition = Duration.zero;
  bool _isSpeedingUp = false;

  @override
  void initState() {
    super.initState();
    _attachListener();
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cachedPlayer != widget.cachedPlayer) {
      oldWidget.cachedPlayer?.controller.removeListener(_videoListener);
      _attachListener();
    }
  }

  void _attachListener() {
    if (widget.cachedPlayer != null) {
      widget.cachedPlayer!.controller.addListener(_videoListener);
      if (widget.cachedPlayer!.isInitialized && _isVisible && !_isUserPaused && !_isFinished) {
        widget.cachedPlayer!.controller.play();
      }
    }
  }

  void _videoListener() {
    final player = widget.cachedPlayer;
    if (player == null || !player.isInitialized) return;
    final position = player.controller.value.position;
    final duration = player.controller.value.duration;

    if (position < _lastPosition && _lastPosition.inMilliseconds > duration.inMilliseconds - 500) {
      _loopCount++;
      if (_loopCount >= _maxLoops) {
        _isFinished = true;
        player.controller.pause();
        if (mounted) setState(() {});
      }
    }
    _lastPosition = position;
  }

  void _toggleMute() {
    final player = widget.cachedPlayer;
    if (player == null) return;
    setState(() {
      _isMuted = !_isMuted;
      player.controller.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  void _togglePlayPause() {
    final player = widget.cachedPlayer;
    if (player == null || !player.isInitialized) return;
    if (player.controller.value.isPlaying) {
      player.controller.pause();
      _isUserPaused = true; 
    } else {
      _isUserPaused = false;
      if (_isFinished) {
        _isFinished = false;
        _loopCount = 0;
        player.controller.seekTo(Duration.zero);
      }
      player.controller.play();
    }
    setState(() {});
  }

  void _startSpeedUp() {
    final player = widget.cachedPlayer;
    if (player != null && player.controller.value.isPlaying) {
      player.controller.setPlaybackSpeed(2.0);
      setState(() => _isSpeedingUp = true);
    }
  }

  void _stopSpeedUp() {
    final player = widget.cachedPlayer;
    if (player != null) {
      player.controller.setPlaybackSpeed(1.0);
      setState(() => _isSpeedingUp = false);
    }
  }

  @override
  void dispose() {
    widget.cachedPlayer?.controller.removeListener(_videoListener);
    widget.cachedPlayer?.controller.setPlaybackSpeed(1.0);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.cachedPlayer;

    return VisibilityDetector(
      key: Key(widget.url),
      onVisibilityChanged: (info) {
        _isVisible = info.visibleFraction > 0.8;
        if (player == null || !mounted || !player.isInitialized) return;
        if (_isVisible) {
          if (!player.controller.value.isPlaying && !_isFinished && !_isUserPaused) {
            player.controller.play();
          }
        } else {
          player.controller.pause();
        }
      },
      child: Container(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (player != null && player.isInitialized)
              Center(
                child: AspectRatio(
                  aspectRatio: player.controller.value.aspectRatio,
                  child: VideoPlayer(player.controller),
                ),
              )
            else
              const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),

            if (player != null && player.isInitialized) ...[
              Positioned.fill(
                child: VideoGestureOverlay(
                  onTap: _togglePlayPause,
                  onLongPressStart: _startSpeedUp,
                  onLongPressEnd: _stopSpeedUp,
                ),
              ),
              VideoPlayPauseIcon(isPlaying: player.controller.value.isPlaying),
              if (_isSpeedingUp)
                Positioned(
                  bottom: 24, 
                  left: 16,
                  child: IgnorePointer(
                    child: VideoTimerAndSpeedOverlay(controller: player.controller),
                  ),
                ),
              Positioned(
                bottom: 24, 
                right: 16,
                child: VideoMuteButton(isMuted: _isMuted, onTap: _toggleMute),
              ),
            ],
          ],
        ),
      ),
    );
  }
}