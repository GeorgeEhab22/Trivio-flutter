import 'package:flutter/material.dart';
import 'package:auth/presentation/home/reactions/reaction_button.dart';

class CommentBody extends StatelessWidget {
  final String text;
  final VoidCallback onReply;
  final bool showReplies;
  final int repliesCount;
  final VoidCallback onToggleReplies;
  final ValueChanged<int> onReactionChanged;

  const CommentBody({
    super.key,
    required this.text,
    required this.onReply,
    required this.showReplies,
    required this.repliesCount,
    required this.onToggleReplies,
    required this.onReactionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 70, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text),
          const SizedBox(height: 4),
          Row(
            children: [
              ReactionButton(
                initialCount: 3,
                onReactionChanged: onReactionChanged,
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: onReply,
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: const Text(
                  "Reply",
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
