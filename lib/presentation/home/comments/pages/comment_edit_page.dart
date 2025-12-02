import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/entities/comment.dart';
import '../../../manager/comment_cubit/comment_cubit.dart';

class CommentEditPage extends StatelessWidget {
  final Comment comment;

  const CommentEditPage({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(
      text: comment.text,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Comment'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final cubit = context.read<CommentCubit>();

                cubit.prepareForEditSubmission(comment);

                cubit.addOrUpdateComment(comment.postId, controller.text);
                  context.pop();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: controller,
          maxLines: null,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Edit your comment...',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

void navigateToEditPage(
  BuildContext context,
  Comment commentToEdit,
  CommentCubit cubit,
) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BlocProvider.value(
        value: cubit,
        child: CommentEditPage(comment: commentToEdit),
      ),
    ),
  );
}
