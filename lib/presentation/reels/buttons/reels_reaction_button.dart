import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/reaction.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/presentation/home/reactions/reaction_action.dart';
import 'package:flutter/material.dart';

class ReelsReactionButton extends StatelessWidget {
  final Post reel;
  final String currentUserId;

  const ReelsReactionButton({
    super.key,
    required this.reel,
    required this.currentUserId,
  });

  ReactionType _resolveCurrentUserReaction() {
    if (reel.userReaction != ReactionType.none) {
      return reel.userReaction;
    }
    final List<Reaction>? reactions = reel.reactions;
    if (reactions == null || reactions.isEmpty) {
      return ReactionType.none;
    }
    for (final reaction in reactions.reversed) {
      if (reaction.userId == currentUserId) {
        return reaction.type;
      }
    }
    return ReactionType.none;
  }

  String? _resolveCurrentUserReactionId() {
    final List<Reaction>? reactions = reel.reactions;
    if (reactions == null || reactions.isEmpty) {
      return null;
    }
    for (final reaction in reactions.reversed) {
      if (reaction.userId == currentUserId) {
        final id = reaction.id.trim();
        if (id.isNotEmpty) {
          return id;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final resolvedReaction = _resolveCurrentUserReaction();
    var resolvedCount = reel.reactionsCount > 0
        ? reel.reactionsCount
        : (reel.reactions?.length ?? 0);

    if (resolvedReaction != ReactionType.none && resolvedCount == 0) {
      resolvedCount = 1;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ReactionAction(
        postId: reel.postID,
        currentUserId: currentUserId,
        initialReaction: resolvedReaction,
        initialCount: resolvedCount,
        initialReactionId: _resolveCurrentUserReactionId(),
        isVertical: true,
      ),
    );
  }
}
