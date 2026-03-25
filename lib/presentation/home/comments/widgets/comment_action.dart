import 'package:auth/injection_container.dart' as di;
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/presentation/home/comments/comments_view.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_cubit.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_state.dart';
import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../widgets/post_action_item.dart';

class CommentAction extends StatelessWidget {
  final int commentsCount;
  final int sharesCount;
  final int reactionsCount;
  final List<ReactionType> topReactions;
  final String postId;
  final String currentUserId;
  final bool isReelView;
final VoidCallback? onReelsCommentTap;

  const CommentAction({
    super.key,
    required this.commentsCount,
    required this.postId,
    required this.currentUserId,
    this.sharesCount = 0,
    this.reactionsCount = 0,
    this.topReactions = const <ReactionType>[],
    this.isReelView = false,
    this.onReelsCommentTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isReelView ? Colors.white : Theme.of(context).iconTheme.color;
    final iconSize = isReelView ? 28.0 : 22.0;
    return PostActionItem(
      icon:  FaIcon(FontAwesomeIcons.comment, size: iconSize,color: iconColor,),
      count: commentsCount,
      color: iconColor,
      isVertical: isReelView,
      onTap: () {
        if (isReelView && onReelsCommentTap != null) {
          onReelsCommentTap!();
          return;
        }
        final postCubit = context.read<PostCubit>();
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useRootNavigator: true,
          backgroundColor: Colors.transparent,
          barrierColor: Colors.black38,
          builder: (ctx) => BlocProvider(
            create: (context) => di.sl<CommentCubit>(),
            child: BlocListener<CommentCubit, CommentState>(
              listener: (_, state) {
                if (state is CommentActionSuccess) {
                  if (state.commentsDelta != 0) {
                    postCubit.incrementCommentsCount(
                      postId,
                      by: state.commentsDelta,
                    );
                  }
                }
              },
              child: CommentsView(
                postId: postId,
                currentUserId: currentUserId,
                sharesCount: sharesCount,
                reactionsCount: reactionsCount,
                topReactions: topReactions,
                isReelView: isReelView,
              ),
            ),
          ),
        );
      },
    );
  }
}
