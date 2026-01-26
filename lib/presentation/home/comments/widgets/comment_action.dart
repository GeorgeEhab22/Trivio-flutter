import 'package:auth/injection_container.dart' as di;
import 'package:auth/presentation/home/comments/comments_view.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../widgets/post_action_item.dart';

class CommentAction extends StatelessWidget {
  final int commentsCount;
  final String postId;
  final String currentUserId;

  const CommentAction({
    super.key,
    required this.commentsCount,
    required this.postId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return PostActionItem(
      icon: const FaIcon(FontAwesomeIcons.comment, size: 22),
      count: commentsCount,
      color: Theme.of(context).iconTheme.color,
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useRootNavigator: true,
          backgroundColor: Colors.transparent,
          barrierColor: Colors.black38,
          builder: (ctx) => BlocProvider(
            create: (context) => di.sl<CommentCubit>(),
            child: CommentsView(postId: postId, currentUserId: currentUserId),
          ),
        );
      },
    );
  }
}
