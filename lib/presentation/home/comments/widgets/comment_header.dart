import 'package:flutter/material.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/home/widgets/author_info.dart';

class CommentHeader extends StatelessWidget {
  final String user;
  final String? userImage;
  final DateTime? time;
  final String commentText;

  final bool isOwner;


  const CommentHeader({
    super.key,
    required this.user,
    this.userImage,
    required this.time,
    required this.commentText,
    required this.isOwner,
 
  });

  @override
  Widget build(BuildContext context) {
    // compute once

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AuthorInfo(
              authorName: user,
              createdAt: time ?? DateTime.now(),
              avatarRadius: 18,
              showTimeInline: true,
              authorTextStyle: Styles.textStyle15,
              authorImage: userImage ?? '',
            ),
          ),

       
          // CommentActionsMenu(
          //   parentContext: context,
          //   commentText: commentText,
          //   isOwner: isOwner,
          //   onReply: onReply,
          //   onEdit: onEdit,
          //   onDelete: onDelete,
          //   onReport: onReport,
          //   onHide: onHide,
          // ),
        ],
      ),
    );
  }
}
