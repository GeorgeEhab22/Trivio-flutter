import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preload_page_view/preload_page_view.dart' hide PageScrollPhysics;
import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:auth/presentation/reels/widgets/reel_item.dart';
import 'package:auth/presentation/reels/widgets/reels_app_bar.dart';

class ReelsView extends StatefulWidget {
  const ReelsView({super.key});

  @override
  State<ReelsView> createState() => _ReelsViewState();
}

class _ReelsViewState extends State<ReelsView> with WidgetsBindingObserver {
  final PreloadPageController _pageController = PreloadPageController();
  final VideoControllerPool _pool = VideoControllerPool();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    _pool.disposeAll();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _pool.pauseAll();
    } else if (state == AppLifecycleState.resumed) {
      _pool.playIndex(_currentIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = context.read<ProfileCubit>().state;
    final String currentUserId = profileState is ProfileLoaded
        ? profileState.user.id
        : "";

    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          } else if (state is PostLoaded) {
            final reels = state.posts.where((p) {
              if (p.media == null || p.media!.isEmpty) return false;
              final m = p.media!.first.toLowerCase();
              return m.endsWith('.mp4') ||
                  m.endsWith('.mov') ||
                  m.endsWith('.webm');
            }).toList();

            if (reels.isEmpty) {
              return const Center(
                child: Text(
                  "No Reels yet",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            if (_pool.isEmpty) {
              _pool.preloadAround(0, reels);
            }

            return Stack(
              children: [
                PreloadPageView.builder(
                  controller: _pageController,
                  preloadPagesCount: 1,
                  scrollDirection: Axis.vertical,
                  physics: const ReelsScrollPhysics(),
                  itemCount: reels.length,
                  onPageChanged: (index) {
                    _currentIndex = index;
                    _pool.preloadAround(index, reels);
                    _pool.playIndex(index);
                    setState(() {}); // update overlays if needed
                  },
                  itemBuilder: (context, index) {
                    final reel = reels[index];
                    final cachedPlayer = _pool.getPlayer(index);
                    return ReelItem(
                      reel: reel,
                      currentUserId: currentUserId,
                      cachedPlayer: cachedPlayer,
                      index: index,
                    );
                  },
                ),
                const ReelsAppBar(),
              ],
            );
          } else if (state is PostError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class VideoControllerPool {
  final Map<int, CachedVideoPlayerPlus> _map = {};
  final Set<int> _creating = {};

  bool get isEmpty => _map.isEmpty;

  CachedVideoPlayerPlus? getPlayer(int idx) => _map[idx];

  void preloadAround(int center, List items) {
    final keep = <int>{center - 1, center, center + 1, center + 2};

    for (final idx in keep) {
      if (idx >= 0 && idx < items.length && !_map.containsKey(idx) && !_creating.contains(idx)) {
        _creating.add(idx);
        _createPlayer(items[idx].media!.first).then((p) {
          if (p != null) {
            _map[idx] = p;
          }
          _creating.remove(idx);
        });
      }
    }

    final toRemove = _map.keys.where((k) => !keep.contains(k)).toList();
    for (final k in toRemove) {
      _map[k]?.controller.pause();
      _map[k]?.dispose(); 
      _map.remove(k);
    }
  }

  Future<CachedVideoPlayerPlus?> _createPlayer(String url) async {
    try {
      final player = CachedVideoPlayerPlus.networkUrl(Uri.parse(url));
      await player.initialize();
      await player.controller.setLooping(true);
      return player;
    } catch (e) {
      debugPrint("Video Error: $e");
      return null;
    }
  }

  void playIndex(int index) {
    _map.forEach((k, player) {
      if (k == index) {
        if (!player.controller.value.isPlaying) player.controller.play();
      } else {
        player.controller.pause();
      }
    });
  }

  void pauseAll() => _map.values.forEach((p) => p.controller.pause());

  void disposeAll() {
    _map.values.forEach((p) => p.dispose());
    _map.clear();
  }
}

class ReelsScrollPhysics extends PageScrollPhysics {
  const ReelsScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  ReelsScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return ReelsScrollPhysics(parent: parent?.applyTo(ancestor) ?? ancestor);
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    double boostedVelocity = velocity;

    if (velocity.abs() > 50 && velocity.abs() < 300) {
      boostedVelocity = velocity.sign * (velocity.abs() * 4.0);
    } else if (velocity.abs() >= 300) {
      boostedVelocity = velocity.sign * (velocity.abs() * 1.5);
    }

    return super.createBallisticSimulation(position, boostedVelocity);
  }

  @override
  SpringDescription get spring => SpringDescription.withDampingRatio(
        mass: 0.5,
        stiffness: 2000,
        ratio: 1.0,
      );
}