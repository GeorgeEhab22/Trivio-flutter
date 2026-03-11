import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/presentation/home/reactions/reaction_action.dart';
import 'package:flutter/material.dart';

class ReelsReactionButton extends StatelessWidget {
  final String postId;
  final String currentUserId;

  const ReelsReactionButton({
    super.key,
    required this.postId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ReactionAction(
        postId: postId,
        currentUserId: currentUserId,
        initialReaction: ReactionType.none,
        initialCount: 1200, // Dynamic count later
      ),
    );
  }
}
