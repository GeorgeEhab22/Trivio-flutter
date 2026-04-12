import 'package:auth/constants/colors.dart';
import 'package:auth/core/custom_app_bar.dart';
import 'package:auth/presentation/home/add_post/add_post_bottom_sheet.dart';
import 'package:auth/presentation/home/posts_in_timeline/time_line_list_view.dart';
import 'package:auth/presentation/home/watch_time/watch_time_tracker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/manager/notifications_cubit/notifications_cubit.dart';
import 'package:auth/presentation/manager/notifications_cubit/notifications_state.dart';
import 'dart:ui';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with RouteAware {
  RouteObserver<ModalRoute<dynamic>>? _routeObserver;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_routeObserver != null) return;
    _routeObserver = context.read<RouteObserver<ModalRoute<dynamic>>>();
    _routeObserver!.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void initState() {
    super.initState();
    context.read<PostCubit>().fetchPosts(refresh: true);
  }

  @override
  void dispose() {
    _routeObserver?.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() => _flushWatchTime();

  @override
  void didPop() => _flushWatchTime();

  void _flushWatchTime() {
    WatchTimeTracker.of(context)?.flushAndDispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PostCubit>();
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return WatchTimeTracker(
      child: BlocListener<PostCubit, PostState>(
        listener: (context, state) {
          if (state is DeletePostSuccess) {
            showCustomSnackBar(context, l10n.postDeletedSuccess, true);
          }
          if (state is DeletePostError) {
            showCustomSnackBar(context, state.message, false);
          }
          if (state is EditPostSuccess) {
            showCustomSnackBar(context, 'Post updated successfully', true);
          }
          if (state is EditPostError) {
            showCustomSnackBar(context, state.message, false);
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    },
                  ),
                  child: RefreshIndicator(
                    color: AppColors.primary,
                    backgroundColor: isDarkMode
                        ? Color(0xFF18191a)
                        : Colors.white,

                    displacement: 0,
                    onRefresh: () async {
                      await context.read<PostCubit>().fetchPosts(refresh: true);
                    },
                    child: CustomScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverAppBar(
                          floating: true,
                          snap: true,
                          automaticallyImplyLeading: false,
                          surfaceTintColor: Colors.transparent,
                          titleSpacing: 0,
                          title:
                              _NotificationAppBar(), // ← separate stateful widget
                        ),
                        const TimelineListView(),
                        const SliverToBoxAdapter(child: SizedBox(height: 100)),
                      ],
                    ),
                  ),
                ),
                _buildAddPostFAB(context, cubit),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddPostFAB(BuildContext context, PostCubit cubit) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: AppColors.darkGreen,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final newPost = await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const AddPostBottomSheet(),
          );
          if (newPost != null && context.mounted) {
            cubit.addNewPostToFeed(newPost);
          }
        },
      ),
    );
  }
}

class _NotificationAppBar extends StatelessWidget {
  const _NotificationAppBar();

  @override
  Widget build(BuildContext context) {
    int count = 0;
    try {
      final state = context.watch<NotificationCubit>().state;
      count = state is NotificationLoaded ? state.newCount : 0;
    } catch (_) {}

    return HomeAppBar(notificationCount: count);
  }
}
