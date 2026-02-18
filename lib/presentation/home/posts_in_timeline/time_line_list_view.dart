import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/groups/widgets/dummy_for_skeletonizer.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/post_card.dart';
import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
// import 'package:auth/l10n/app_localizations.dart';

class TimelineListView extends StatelessWidget {
  const TimelineListView({super.key});

  @override
  Widget build(BuildContext context) {

    // final l10n = AppLocalizations.of(context)!;
    
   
    return BlocConsumer<PostCubit, PostState>(
      listener: (context, state) {
        if (state is PostsLoadingMoreError) {
          // Use localized helper if state.message is a technical key
          showCustomSnackBar(context, state.message, false);
        }
      },
      builder: (context, state) {
        final cubit = context.read<PostCubit>();
        final bool isLoading = state is PostLoading && cubit.posts.isEmpty;
        final posts = (state is PostLoaded || cubit.posts.isNotEmpty)
            ? cubit.posts
            : DummyData.dummyPosts;
        if (state is PostError && cubit.posts.isEmpty) {
          return SliverFillRemaining(child: Center(child: Text(state.message)));
        }
        return Skeletonizer.sliver(
          enabled: isLoading,
          child: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index >= posts.length) {
                return Skeletonizer(
                  enabled: true,
                  child: PostCard(
                    post: DummyData.dummyPost,
                    currentUserId: '1',
                    isFollowing: false,
                  ),
                );
              }

              return PostCard(
                post: posts[index],
                //TODO: add currentUserId after login
                currentUserId: '1',
                isFollowing: false,
              );
            }, childCount: posts.length + (state is PostsLoadingMore ? 1 : 0)),
          ),
        );
      },
    );
  }
}