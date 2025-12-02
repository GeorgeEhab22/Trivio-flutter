import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_cubit.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_state.dart';
import 'comments_input_field.dart';

class InputFieldBlocBuilder extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String postId;

  const InputFieldBlocBuilder({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommentCubit, CommentState>(
      listener: (context, state) {
        final cubit = context.read<CommentCubit>();
        if (state is CommentLoaded && cubit.replyingTo != null) {
          Future.delayed(const Duration(milliseconds: 100), () {
            if (context.mounted) focusNode.requestFocus();
          });
        }
      },
      builder: (context, state) {
        final cubit = context.read<CommentCubit>();
        String? replyingName;
        if (state is CommentLoaded) {
          replyingName = state.replyingToComment?.authorName;
        }
        return CommentInputField(
          controller: controller,
          focusNode: focusNode,
          replyingToUser: replyingName,

          onCancelReply: () {
            cubit.cancelReplyOrEdit();
            focusNode.unfocus();
          },

          onSubmitted: (text) {
            cubit.addOrUpdateComment(postId, text);
            controller.clear();
            focusNode.unfocus();
          },
        );
      },
    );
  }
}
