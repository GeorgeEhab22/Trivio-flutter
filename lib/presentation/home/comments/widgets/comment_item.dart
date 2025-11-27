import 'package:auth/domain/entities/comment.dart';
import 'package:flutter/material.dart';
import 'package:auth/presentation/home/comments/widgets/comment_header.dart';
import 'package:auth/presentation/home/comments/widgets/comment_body.dart';
import 'package:auth/presentation/home/comments/widgets/comment_replies_list.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  final List<Comment>? replies;

  final String currentUserId;
  final bool showReplies;
  final String? replyingTo;

  const CommentItem({
    super.key,
    required this.comment,
    required this.currentUserId,
    this.replyingTo,
    this.replies,
    this.showReplies = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = comment;
    final repliesList = replies ?? [];
    final bool isOwner = c.authorId == currentUserId;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommentHeader(
          user: c.authorName,
          userImage: c.authorImage,
          time: c.createdAt,
          commentText: c.text,
          isOwner: isOwner,
        ),

        if (replyingTo != null && replyingTo!.isNotEmpty)
          const SizedBox(height: 4),

        if (replyingTo != null && replyingTo!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 54, bottom: 4),
            child: Text(
              "Replying to $replyingTo",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

        CommentBody(
          text: c.text,
          showReplies: showReplies,
          repliesCount: repliesList.length,
          
        ),

        if (repliesList.isNotEmpty && showReplies)
          Padding(
            padding: EdgeInsets.only(
              left: c.isReply ? 50 : 60,
              top: 4,
              bottom: 4,
            ),
            child: CommentRepliesList(
              key: ValueKey('replies_${c.id}'),
              currentUserId: currentUserId,
              replies: repliesList,

            ),
          ),
      ],
    );

    final topKey = ValueKey(c.id);

    return c.isReply
        ? Transform.scale(
            key: topKey,
            scale: 0.95,
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 50, bottom: 6),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: content,
            ),
          )
        : KeyedSubtree(key: topKey, child: content);
  }
}
