// lib/presentation/home/watch_time/watch_time_tracker.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';

class WatchTimeTracker extends StatefulWidget {
  final Widget child;
  const WatchTimeTracker({super.key, required this.child});

  static WatchTimeTrackerState? of(BuildContext context) =>
      context.findAncestorStateOfType<WatchTimeTrackerState>();

  @override
  State<WatchTimeTracker> createState() => WatchTimeTrackerState();
}

class WatchTimeTrackerState extends State<WatchTimeTracker>
    with WidgetsBindingObserver {
  final Set<String> _watchedPostIds = {};
  final Map<String, Timer> _pendingTimers = {};
  Timer? _batchTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startBatchTimer();
  }

  void _startBatchTimer() {
    _batchTimer = Timer.periodic(const Duration(minutes: 5), (_) => _flush());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      _flush();
    }
  }

  void onPostVisible(String postId) {
    if (_watchedPostIds.contains(postId)) return;
    if (_pendingTimers.containsKey(postId)) return;

    _pendingTimers[postId] = Timer(const Duration(seconds: 3), () {
      _pendingTimers.remove(postId);
      _watchedPostIds.add(postId);
    });
  }

  void onPostHidden(String postId) {
    _pendingTimers[postId]?.cancel();
    _pendingTimers.remove(postId);
  }

  void _flush() {
    if (_watchedPostIds.isEmpty) return;
    final ids = List<String>.from(_watchedPostIds);
    _watchedPostIds.clear();
    context.read<PostCubit>().markPostsAsWatched(ids);
  }

  void flushAndDispose() => _flush(); 

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _batchTimer?.cancel();
    for (final t in _pendingTimers.values) {
      t.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}