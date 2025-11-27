import 'package:flutter/material.dart';
import 'package:auth/presentation/home/reactions/reaction_button.dart';

class CommentBody extends StatelessWidget {
  final String text;
  final bool showReplies;
  final int repliesCount;
  final int initialReactionCount;

  const CommentBody({
    super.key,
    required this.text,
    required this.showReplies,
    required this.repliesCount,
    this.initialReactionCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 70, right: 10),
      child: _CommentBodyView(),
    );
  }
}


class _CommentBodyView extends StatelessWidget {
  const _CommentBodyView();

  @override
  Widget build(BuildContext context) {
    final parent = context.findAncestorWidgetOfExactType<CommentBody>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(parent.text),
        const SizedBox(height: 4),
        Row(
          children: [

            ReactionButton(
              initialCount: parent.initialReactionCount,
              onReactionChanged: (_){},
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed:() {},
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: const Text(
                "Reply",
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
