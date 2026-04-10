
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'watch_time_tracker.dart';

class PostVisibilityDetector extends StatelessWidget {
  final String postId;
  final Widget child;

  const PostVisibilityDetector({
    super.key,
    required this.postId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final tracker = WatchTimeTracker.of(context);

    return VisibilityDetector(
      key: Key('post_$postId'),
      onVisibilityChanged: (info) {
        if (tracker == null) return;
        if (info.visibleFraction >= 0.5) {
          tracker.onPostVisible(postId);
        } else {
          tracker.onPostHidden(postId);
        }
      },
      child: child,
    );
  }
}