import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../posts_in_timeline/post_card.dart';

class PostsBlocConsumer extends StatelessWidget {
  const PostsBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      listener: (context, state) {
        if (state is PostsLoadingMoreError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<PostCubit>();
        final posts = cubit.posts;

        if (state is PostLoading && posts.isEmpty) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is PostError && posts.isEmpty) {
          return SliverFillRemaining(
            child: Center(child: Text(state.message)),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index >= posts.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return PostCard(post: posts[index]);
            },
            childCount: posts.length + (state is PostsLoadingMore ? 1 : 0),
          ),
        );
      },
    );
  }
}