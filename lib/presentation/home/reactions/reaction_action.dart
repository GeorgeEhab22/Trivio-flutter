import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
import 'package:auth/presentation/manager/post_cubit/post_interaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'reaction_interaction.dart';

class ReactionAction extends StatelessWidget {
  final String postId;
  final ReactionType initialReaction;
  final int initialCount;
  final String? initialReactionId;

  const ReactionAction({
    super.key,
    required this.postId,
    required this.initialReaction,
    required this.initialCount,
    this.initialReactionId,
  });

  @override
  Widget build(BuildContext context) {
    final interactionCubit = context.read<PostInteractionCubit>();
    interactionCubit.primeReactionId(
      postId: postId,
      reactionId: initialReactionId,
    );

    return BlocConsumer<PostInteractionCubit, PostInteractionState>(
      listenWhen: (previous, current) =>
          (current is PostReactionUpdated && current.postId == postId) ||
          (current is ReactToPostSuccess && current.postId == postId) ||
          (current is ReactToPostError && current.postId == postId),
      listener: (context, state) {
        PostCubit? postCubit;
        try {
          postCubit = context.read<PostCubit>();
        } catch (_) {
          postCubit = null;
        }
        if (postCubit == null) {
          return;
        }

        if (state is PostReactionUpdated && state.postId == postId) {
          postCubit.updatePostReaction(
            postId: postId,
            reactionType: state.reactionType,
            reactionsCount: state.count,
          );
        }

        if (state is ReactToPostError && state.postId == postId) {
          postCubit.updatePostReaction(
            postId: postId,
            reactionType: state.oldReactionType ?? initialReaction,
            reactionsCount: state.oldCount ?? initialCount,
          );
        }
      },
      buildWhen: (previous, current) =>
          (current is PostReactionUpdated && current.postId == postId) ||
          (current is ReactToPostSuccess && current.postId == postId) ||
          (current is ReactToPostError && current.postId == postId),
      builder: (context, state) {
        ReactionType currentReaction = initialReaction;
        int currentCount = initialCount;
        String? currentReactionId =
            interactionCubit.reactionIdForPost(postId) ?? initialReactionId;

        if (state is PostReactionUpdated && state.postId == postId) {
          currentReaction = state.reactionType;
          currentCount = state.count;
          currentReactionId = state.reactionId ?? currentReactionId;
        }
        if (state is ReactToPostSuccess && state.postId == postId) {
          currentReaction = state.reactionType;
          currentReactionId = state.reactionId ?? currentReactionId;
        }
        if (state is ReactToPostError && state.postId == postId) {
          currentReaction = state.oldReactionType ?? initialReaction;
          currentCount = state.oldCount ?? initialCount;
          currentReactionId = state.oldReactionId ?? currentReactionId;
        }

        return ReactionInteraction(
          reactionType: currentReaction,
          count: currentCount,

          onTap: () {
            context.read<PostInteractionCubit>().toggleReaction(
              postId: postId,
              currentReaction: currentReaction,
              currentCount: currentCount,
              currentReactionId: currentReactionId,
            );
          },

          onReactionSelected: (chosenType) {
            context.read<PostInteractionCubit>().chooseReaction(
              postId: postId,
              chosenType: chosenType,
              currentReaction: currentReaction,
              currentCount: currentCount,
              currentReactionId: currentReactionId,
            );
          },
        );
      },
    );
  }
}
