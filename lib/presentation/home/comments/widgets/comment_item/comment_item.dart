import 'package:auth/constants/colors';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/injection_container.dart' as di;
import 'package:auth/presentation/home/reactions/reaction_action.dart';
import 'package:auth/presentation/home/widgets/exbandable_text.dart';
import 'package:auth/presentation/manager/post_cubit/post_interaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:auth/domain/entities/comment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'comment_header.dart';
import '../lists/comment_replies_list.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  final String currentUserId;
  final Function(Comment comment)? onReplyTap;
  final List<Comment> replies;
  final ReactionType? initialReaction;

  const CommentItem({
    super.key,
    required this.comment,
    required this.currentUserId,
    this.onReplyTap,
    this.replies = const [],
    this.initialReaction,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOwner = comment.authorId == currentUserId;
    final bool isReply = comment.isReply;

    final Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommentHeader(
          isOwner: true,
          comment: comment, //TODO : later remove true and use isOwner
        ),

        Padding(
          padding: const EdgeInsets.only(left: 56, right: 16),
          child: ExpandableText(
            text: comment.text,
            previewLines: 2,
            canCollapse: false,
          )),

        Padding(
          padding: const EdgeInsets.only(left: 56, right: 16),
          child: Row(
            children: [
              BlocProvider(
                create: (context) =>di.sl<PostInteractionCubit>(),
                child: ReactionAction(
                  postId: comment.id,
                  userId: currentUserId,
                  initialReaction: initialReaction ?? ReactionType.none,
                  initialCount: comment.reactions.length,
                ),
              ),
              TextButton(
                onPressed: (){
                  if (onReplyTap != null) {
                    onReplyTap!(comment);
                  }
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.centerLeft,
                ),
                child: const Text(
                  "Reply",
                  style: TextStyle(color: AppColors.lightGrey, fontSize: 13),
                ),
              ),
              // Add Like Button here later
            ],
          ),
        ),
        if (replies.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(left: isReply ? 40.0 : 50.0),
            child: CommentRepliesList(
              replies: replies,
              currentUserId: currentUserId,
              onReplyTap: onReplyTap,
            ),
          ),
      ],
    );

    if (isReply) {
      return Container(
        margin: const EdgeInsets.only(left: 40, bottom: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: content,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: content,
    );
  }
}
