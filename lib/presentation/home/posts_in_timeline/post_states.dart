import 'package:flutter/material.dart';
import '../reactions/reaction_button.dart';
import '../comments/comment_button.dart';
import '../share_post/share_button.dart';
//TODO: use proper entity instead of individual parameters and handle all states via Bloc

class PostStates extends StatefulWidget {
  final int reactions;
  final int comments;
  final int shares;

  const PostStates({
    super.key,
    required this.reactions,
    required this.comments,
    required this.shares,
  });

  @override
  State<PostStates> createState() => _PostStatesState();
}

class _PostStatesState extends State<PostStates> {
  late int _reactionsCount;
  late int _commentCount;
  late int _shareCount;

  @override
  void initState() {
    super.initState();
    _reactionsCount = widget.reactions;
    _commentCount = widget.comments;
    _shareCount = widget.shares;
  }

  void _incrementShares() => setState(() => _shareCount++);
  void _incrementComments() => setState(() => _commentCount++);
  void _decrementComments() => setState(() => _commentCount--);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double spacing = screenWidth < 350
        ? 12
        : screenWidth < 600
        ? 20
        : 28;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          ReactionButton(
            initialCount: _reactionsCount,
            onReactionChanged: (count) {
              setState(() => _reactionsCount = count);
            },
          ),
          SizedBox(width: spacing),
          CommentButton(
            commentsCount: _commentCount,
            reactionsCount: _reactionsCount,
            onCommentAdded: _incrementComments,
            onCommentDeleted: _decrementComments,

            // TODO: Call add/delete comment use-case here
            // Example:
            // context.read<CommentCubit>().addComment(postId, text)
          ),
          SizedBox(width: spacing),
          ShareButton(
            count: _shareCount,
            onShare: _incrementShares,
            // TODO: Call share post use-case here
            // Example:
            // context.read<SharePostCubit>().share(postId)
          ),
          const Spacer(),

        ],
      ),
    );
  }
}
