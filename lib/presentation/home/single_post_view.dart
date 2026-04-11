import 'package:auth/domain/entities/post.dart';
import 'package:auth/presentation/home/comments/comments_view.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/get_user_profile_by_id_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:auth/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/post_card.dart';
import 'package:auth/presentation/manager/post_cubit/get_post/get_post_state.dart';
import 'package:auth/presentation/manager/post_cubit/get_post/get_post_cubit.dart';
import 'package:go_router/go_router.dart';

class SinglePostView extends StatefulWidget {
  final String postId;
  final String? targetCommentId;

  const SinglePostView({super.key, required this.postId, this.targetCommentId});

  @override
  State<SinglePostView> createState() => _SinglePostViewState();
}

class _SinglePostViewState extends State<SinglePostView> {
  @override
  void initState() {
    super.initState();
    context.read<GetPostCubit>().getPost(widget.postId);
  }

  void _openCommentsSheet(BuildContext context, Post post) {
    final profileState = context.read<ProfileCubit>().state;
    String userId = '';
    if (profileState is ProfileLoaded) {
      userId = profileState.user.id;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black38,
      builder: (ctx) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => di.sl<CommentCubit>()),
          BlocProvider(create: (context) => di.sl<GetUserProfileByIdCubit>()),
        ],
        child: CommentsView(
          postId: post.postID,
          currentUserId: userId,
          targetCommentId: widget.targetCommentId,
          reactionsCount: post.reactionsCount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 30),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocConsumer<GetPostCubit, GetPostState>(
        listener: (context, state) {
          if (state is GetPostSuccess && widget.targetCommentId != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _openCommentsSheet(context, state.post);
            });
          }
        },
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
              child: PostCard(
                post: state.post,
                currentUserId: currentUserId,
                targetCommentId: widget.targetCommentId,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
