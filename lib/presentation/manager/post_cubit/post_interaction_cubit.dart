import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/domain/usecases/post/comment_on_post_usecase.dart';
import 'package:auth/domain/usecases/post/react_to_post_usecase.dart';
import 'package:auth/domain/usecases/post/remove_reaction_from_post_usecase.dart';
import 'package:auth/domain/usecases/post/report_post_usecase.dart';
import 'package:auth/domain/usecases/post/share_post_usecase.dart';
import 'package:auth/domain/usecases/post/follow_user.dart';
import 'package:auth/domain/usecases/post/save_post_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'post_interaction_state.dart';

class PostInteractionCubit extends Cubit<PostInteractionState> {
  final ReactToPostUseCase reactToPostUseCase;
  final RemoveReactionFromPostUseCase removeReactionFromPostUseCase;
  final CommentOnPostUseCase commentOnPostUseCase;
  final ReportPostUseCase reportPostUseCase;
  final SharePostUseCase sharePostUseCase;
  final SavePostUseCase toggleSavePostUseCase;
  final FollowUserUseCase followUserUseCase;

  PostInteractionCubit({
    required this.reactToPostUseCase,
    required this.removeReactionFromPostUseCase,
    required this.commentOnPostUseCase,
    required this.reportPostUseCase,
    required this.sharePostUseCase,
    required this.toggleSavePostUseCase,
    required this.followUserUseCase,
  }) : super(PostInteractionInitial());

  // react to post
  Future<void> toggleReaction({
    required String postId,
    required String userId,
    required ReactionType currentReaction,
    required int currentCount,
  }) async {
    final wasGoal = currentReaction == ReactionType.goal;
    int newCount = currentCount;
    ReactionType newReaction = currentReaction;

    // TODO:later add offside logic
    if (wasGoal) {
      newReaction = ReactionType.none;
      newCount = (newCount - 1).clamp(0, 1 << 30);
    } else {
      if (currentReaction == ReactionType.none) {
        newCount = newCount + 1;
      }
      newReaction = ReactionType.goal;
    }

    emit(
      PostReactionUpdated(
        postId: postId,
        reactionType: newReaction,
        count: newCount,
      ),
    );

    if (newReaction == ReactionType.none) {
      await _performRemoveReaction(
        postId: postId,
        userId: userId,
        oldReaction: currentReaction,
        oldCount: currentCount,
      );
    } else {
      await _performReactApiCall(
        postId: postId,
        userId: userId,
        reactionType: newReaction,
        oldReaction: currentReaction,
        oldCount: currentCount,
      );
    }
  }

  Future<void> chooseReaction({
    required String postId,
    required String userId,
    required ReactionType chosenType,
    required ReactionType currentReaction,
    required int currentCount,
  }) async {
    final wasNone = currentReaction == ReactionType.none;
    int newCount = currentCount;

    if (wasNone) {
      newCount = newCount + 1;
    }

    emit(
      PostReactionUpdated(
        postId: postId,
        reactionType: chosenType,
        count: newCount,
      ),
    );

    await _performReactApiCall(
      postId: postId,
      userId: userId,
      reactionType: chosenType,
      oldReaction: currentReaction,
      oldCount: currentCount,
    );
  }

  Future<void> _performReactApiCall({
    required String postId,
    required String userId,
    required ReactionType reactionType,
    required ReactionType oldReaction,
    required int oldCount,
  }) async {
    final result = await reactToPostUseCase(
      postId: postId,
      userId: userId,
      reactionType: reactionType,
    );

    result.fold(
      (failure) {
        emit(
          ReactToPostError(
            postId: postId,
            message: failure.message,
            errorType: 'server',
            oldReactionType: oldReaction,
            oldCount: oldCount,
          ),
        );
      },
      (post) {
        emit(
          ReactToPostSuccess(
            postId: post.postID ?? '',
            reactionType: reactionType,
          ),
        );
      },
    );
  }

  Future<void> _performRemoveReaction({
    required String postId,
    required String userId,
    required ReactionType oldReaction,
    required int oldCount,
  }) async {
    final result = await removeReactionFromPostUseCase(
      postId: postId,
      userId: userId,
    );

    result.fold(
      (failure) {
        emit(
          ReactToPostError(
            postId: postId,
            message: failure.message,
            errorType: 'server',
            oldReactionType: oldReaction,
            oldCount: oldCount,
          ),
        );
      },
      (post) {
        emit(
          ReactToPostSuccess(postId: postId, reactionType: ReactionType.none),
        );
      },
    );
  }

  Future<void> sharePost({
    required String postId,
    required String userId,
    String? additionalContent,
  }) async {
    emit(SharePostLoading(postId: postId));

    final result = await sharePostUseCase(
      postId: postId,
      userId: userId,
      additionalContent: additionalContent,
    );

    result.fold(
      (failure) => emit(_mapShareFailureToState(failure, postId)),
      (post) => emit(SharePostSuccess(post: post)),
    );
  }

  SharePostError _mapShareFailureToState(Failure failure, String postId) {
    switch (failure.runtimeType) {
      case const (ValidationFailure):
        return SharePostError(
          postId: postId,
          message: failure.message,
          errorType: 'validation',
        );
      case const (NetworkFailure):
        return SharePostError(
          postId: postId,
          message: failure.message,
          errorType: 'network',
        );
      default:
        return SharePostError(
          postId: postId,
          message: failure.message,
          errorType: 'server',
        );
    }
  }

  void resetShareState() => emit(PostInteractionInitial());
  bool get isShareLoading => state is SharePostLoading;
  bool get isShareSuccess => state is SharePostSuccess;
  bool get isShareFailure => state is SharePostError;
  bool get isShareInitial => state is PostInteractionInitial;

  String? get shareErrorMessage =>
      state is SharePostError ? (state as SharePostError).message : null;

  // save post

  Future<void> toggleSavePost({
    required String postId,
    required String userId,
    required bool currentSavedStatus,
  }) async {
    final newStatus = !currentSavedStatus;
    emit(PostSaveUpdated(isSaved: newStatus));

    final result = await toggleSavePostUseCase(postId: postId, userId: userId);

    result.fold(
      (failure) {
        emit(
          SavePostError(
            postId: postId,
            message: failure.message,
            oldStatus: currentSavedStatus,
          ),
        );
      },
      (updatedPost) {
        emit(SavePostSuccess(postId: postId, isSaved: newStatus));
      },
    );
  }

  // follow user
  Future<void> toggleFollowUser({
    required String followerId,
    required String followeeId,
    required bool currentFollowStatus,
  }) async {
    // 1. Optimistic Update
    final newStatus = !currentFollowStatus;
    emit(PostFollowUpdated(isFollowing: newStatus));

    final result = await followUserUseCase(
      followedUserId: followeeId,
      followerUserId: followerId,
    );

    result.fold(
      (failure) {
        emit(
          FollowUserError(
            message: failure.message,
            oldStatus: currentFollowStatus,
          ),
        );
      },
      (_) {
        emit(FollowUserSuccess(userId: followeeId, isFollowing: newStatus));
      },
    );
  }

  // report post

  Future<void> reportPost({
    required String postId,
    required String userId,
    required String reason,
  }) async {
    emit(ReportPostLoading(postId: postId));

    final result = await reportPostUseCase(
      postId: postId,
      userId: userId,
      reason: reason,
    );

    result.fold(
      (failure) => emit(ReportPostError(postId: postId, message: failure.message)),
      (_) => emit(ReportPostSuccess(postId: postId)),
    );
  }

  void resetState() {
    emit(PostInteractionInitial());
  }
}
