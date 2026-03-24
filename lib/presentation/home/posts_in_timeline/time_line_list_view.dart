import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/groups/widgets/dummy_for_skeletonizer.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/post_card.dart';
import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TimelineListView extends StatelessWidget {

  const TimelineListView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<PostCubit, PostState>(
      listener: (context, state) {
        if (state is PostsLoadingMoreError) {
          showCustomSnackBar(context, state.message, false);
        }
      },
      builder: (context, state) {
        final cubit = context.read<PostCubit>();
        final bool isInitialLoading =
            state is PostLoading && cubit.posts.isEmpty;
        final bool isLoadingMore = state is PostsLoadingMore;

        final displayPosts = isInitialLoading
            ? DummyData.dummyPosts
            : cubit.posts;

        if (state is PostError && cubit.posts.isEmpty) {
          return SliverFillRemaining(child: Center(child: Text(state.message)));
        }

        if (state is PostLoaded && cubit.posts.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  l10n.noPostsAvailable,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ),
          );
        }

        if (!isInitialLoading && cubit.posts.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) {
              return;
            }
            final profileState = context.read<ProfileCubit>().state;
            String currentUserId = '';
            if (profileState is ProfileLoaded) {
              currentUserId = profileState.user.id;
            }
            context.read<PostCubit>().hydrateCurrentUserReactions(
              currentUserId: currentUserId,
            );
          });
        }

        return Skeletonizer.sliver(
          enabled: isInitialLoading,
          child: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index >= displayPosts.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.green),
                  ),
                );
              }
              final state = context.read<ProfileCubit>().state;
              String currentUserId = '';
              if (state is ProfileLoaded) {
                currentUserId = state.user.id;
              }
              return PostCard(
                post: displayPosts[index],
                currentUserId: currentUserId,
                isFollowing: false,
              );
            }, childCount: displayPosts.length + (isLoadingMore ? 1 : 0)),
          ),
        );
      },
    );
  }
}
