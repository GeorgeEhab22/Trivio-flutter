import 'package:auth/common/functions/bottom_sheet_manager.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/domain/entities/comment.dart';
import 'package:auth/presentation/home/widgets/author_info.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentHeader extends StatelessWidget {
  final Comment comment;
  final bool isOwner;

  const CommentHeader({super.key, required this.comment, this.isOwner = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AuthorInfo(
              authorName: comment.authorName,
              createdAt: comment.createdAt,
              avatarRadius: 18,
              showTimeInline: true,
              authorTextStyle: Styles.textStyle15,
              authorImage: comment.authorImage ?? '',
            ),
          ),
          if (isOwner)
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.grey[700]),
              onPressed: () {
                final cubit = context.read<CommentCubit>();
                BottomSheetManager.showActions(
                  context,
                  comment: comment,
                  isOwner: isOwner,
                  cubit: cubit,
                );
              },
            ),
        ],
      ),
    );
  }
}
