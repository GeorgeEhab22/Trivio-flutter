import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/presentation/manager/post_cubit/post_interaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'reaction_interaction.dart';

class ReactionAction extends StatelessWidget {
  final String postId;
  final String userId;
  final ReactionType initialReaction;
  final int initialCount;

  const ReactionAction({
    super.key,
    required this.postId,
    required this.userId,
    required this.initialReaction,
    required this.initialCount,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostInteractionCubit, PostInteractionState>(
      buildWhen: (previous, current) =>
          (current is PostReactionUpdated && current.postId == postId) ||
          (current is ReactToPostError && current.postId == postId) ||
          current is PostInteractionInitial,
      builder: (context, state) {
        ReactionType currentReaction = initialReaction;
        int currentCount = initialCount;

        if (state is PostReactionUpdated && state.postId == postId) {
          currentReaction = state.reactionType;
          currentCount = state.count;
        }
        if (state is ReactToPostError && state.postId == postId) {
          currentReaction = state.oldReactionType ?? initialReaction;
          currentCount = state.oldCount ?? initialCount;
        }

        return ReactionInteraction(
          reactionType: currentReaction,
          count: currentCount,
          
          onTap: () {
            context.read<PostInteractionCubit>().toggleReaction(
                  postId: postId,
                  userId: userId,
                  currentReaction: currentReaction,
                  currentCount: currentCount,
                );
          },
          
          onReactionSelected: (chosenType) {
            context.read<PostInteractionCubit>().chooseReaction(
                  postId: postId,
                  userId: userId,
                  chosenType: chosenType,
                  currentReaction: currentReaction,
                  currentCount: currentCount,
                );
          },
        );
      },
    );
  }
}
