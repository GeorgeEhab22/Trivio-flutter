
import 'package:auth/domain/entities/comment.dart';
import 'package:auth/presentation/home/comments/widgets/comments_header.dart';
import 'package:auth/presentation/home/comments/widgets/comments_list.dart';
import 'package:auth/presentation/home/comments/widgets/comments_input_field.dart';
import 'package:flutter/material.dart';

class CommentsBottomSheet extends StatelessWidget {
  final int reactionsCount;
  final String postId;
  final String currentUserId;

  const CommentsBottomSheet({
    super.key,
    required this.reactionsCount,
    required this.postId,
    required this.currentUserId,
  });


  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final maxHeight = MediaQuery.of(context).size.height * 0.95;

    final List<Comment> dummyComments = List.generate(5, (index) {
      return Comment(
        id: '$index',
        postId: postId,
        authorId: 'user$index',
        authorName: 'User $index',
        authorImage: '',
        text: 'This is a sample comment number $index',
        createdAt: DateTime.now().subtract(Duration(minutes: index * 5)),
        parentCommentId: null,
        reactions: [],
      );
    });


    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Container(
        height: maxHeight,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 8),

            CommentsHeader(reactionsCount: reactionsCount),
            const Divider(height: 1),

            Expanded(
              child: CommentsList(
                comments: dummyComments,
                listKey: GlobalKey<AnimatedListState>(),
               
                currentUserId: currentUserId,

                scrollController:
                    ScrollController(),
              ),
            ),

            CommentInputField(
              controller: TextEditingController(), 
              focusNode: FocusNode(),
              replyingTo: null, 
              
            ),
          ],
        ),
      ),
    );
  }
}
