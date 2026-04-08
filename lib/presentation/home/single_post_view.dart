import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/post_card.dart';
import 'package:auth/presentation/manager/post_cubit/get_post/get_post_state.dart';
import 'package:auth/presentation/manager/post_cubit/get_post/get_post_cubit.dart';

class SinglePostView extends StatefulWidget {
  final String postId;

  const SinglePostView({super.key, required this.postId});

  @override
  State<SinglePostView> createState() => _SinglePostViewState();
}

class _SinglePostViewState extends State<SinglePostView> {
  @override
  void initState() {
    super.initState();
    context.read<GetPostCubit>().getPost(widget.postId);
  }

  // @override
  // void dispose() {
  //   context.read<GetPostCubit>().close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post'), centerTitle: true),
      body: BlocBuilder<GetPostCubit, GetPostState>(
        builder: (context, state) {
          if (state is GetPostLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF1DB954)),
            );
          } else if (state is GetPostFailure) {
            return Center(child: Text(state.message));
          } else if (state is GetPostSuccess) {
            String currentUserId = '';
            final profileState = context.read<ProfileCubit>().state;
            if (profileState is ProfileLoaded) {
              currentUserId = profileState.user.id;
            }

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: PostCard(post: state.post, currentUserId: currentUserId),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
