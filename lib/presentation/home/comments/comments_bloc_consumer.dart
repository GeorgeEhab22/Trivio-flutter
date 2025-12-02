import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_cubit.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_state.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'widgets/lists/comments_list.dart';

class CommentsBlocConsumer extends StatelessWidget {
  final String currentUserId;

  const CommentsBlocConsumer({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommentCubit, CommentState>(
      listener: (context, state) {
        if (state is CommentActionError) {
          showCustomSnackBar(context, state.message, false);
        }
      },
      buildWhen: (previous, current) {
        return current is CommentLoaded ||
            current is CommentLoading ||
            current is CommentError;
      },
      builder: (context, state) {
        if (state is CommentLoading) {
          return Skeletonizer(
            child: CommentsList(
              comments: state.comments,
              currentUserId: currentUserId,
              onReplyTap: (_) {},
            ),
          );
        } else if (state is CommentError) {
          return Center(child: Text(state.message));
        } else if (state is CommentLoaded) {
          return CommentsList(
            comments: state.comments,
            currentUserId: currentUserId,
            onReplyTap: (comment) {
              context.read<CommentCubit>().triggerReply(comment);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
