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
  final Map<String, String> _reactionIdsByPost = {};

  PostInteractionCubit({
    required this.reactToPostUseCase,
    required this.removeReactionFromPostUseCase,
    required this.commentOnPostUseCase,
    required this.reportPostUseCase,
    required this.sharePostUseCase,
    required this.toggleSavePostUseCase,
    required this.followUserUseCase,
  }) : super(PostInteractionInitial());

  String? reactionIdForPost(String postId) {
    final value = _reactionIdsByPost[postId]?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }
    return value;
  }

  void primeReactionId({required String postId, String? reactionId}) {
    if (postId.trim().isEmpty) {
      return;
    }
    final normalized = reactionId?.trim();
    if (normalized == null || normalized.isEmpty) {
      return;
    }
    _reactionIdsByPost[postId] = normalized;
  }

  // react to post
  Future<void> toggleReaction({
    required String postId,
    required ReactionType currentReaction,
    required int currentCount,
    String? currentReactionId,
  }) async {
    int newCount = currentCount;
    ReactionType newReaction = currentReaction;

    if (currentReaction == ReactionType.none) {
      newReaction = ReactionType.like;
      newCount = newCount + 1;
    } else {
      newReaction = ReactionType.none;
      newCount = (newCount - 1).clamp(0, 1 << 30);
    }

    emit(
      PostReactionUpdated(
        postId: postId,
        reactionType: newReaction,
        count: newCount,
        reactionId: currentReactionId,
      ),
    );

    if (newReaction == ReactionType.none) {
      await _performRemoveReaction(
        postId: postId,
        oldReaction: currentReaction,
        oldCount: currentCount,
        oldReactionId: currentReactionId,
      );
    } else {
      await _performReactApiCall(
        postId: postId,
        reactionType: newReaction,
        oldReaction: currentReaction,
        oldCount: currentCount,
        oldReactionId: currentReactionId,
      );
    }
  }

  Future<void> chooseReaction({
    required String postId,
    required ReactionType chosenType,
    required ReactionType currentReaction,
    required int currentCount,
    String? currentReactionId,
  }) async {
    if (chosenType == ReactionType.none) {
      return;
    }

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
        reactionId: currentReactionId,
      ),
    );

    await _performReactApiCall(
      postId: postId,
      reactionType: chosenType,
      oldReaction: currentReaction,
      oldCount: currentCount,
      oldReactionId: currentReactionId,
    );
  }

  Future<void> _performReactApiCall({
    required String postId,
    required ReactionType reactionType,
    required ReactionType oldReaction,
    required int oldCount,
    String? oldReactionId,
  }) async {
    final result = await reactToPostUseCase(
      postId: postId,
      reactionType: reactionType,
      isUpdate: oldReaction != ReactionType.none,
      reactionId: oldReactionId,
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
            oldReactionId: oldReactionId,
          ),
        );
      },
      (updatedReactionId) {
        final normalizedUpdatedId = updatedReactionId?.trim();
        final normalizedOldId = oldReactionId?.trim();
        final resolvedReactionId =
            (normalizedUpdatedId != null && normalizedUpdatedId.isNotEmpty)
            ? normalizedUpdatedId
            : ((normalizedOldId != null && normalizedOldId.isNotEmpty)
                  ? normalizedOldId
                  : null);

        if (reactionType == ReactionType.none) {
          _reactionIdsByPost.remove(postId);
        } else if (resolvedReactionId != null) {
          _reactionIdsByPost[postId] = resolvedReactionId;
        }

        emit(
          ReactToPostSuccess(
            postId: postId,
            reactionType: reactionType,
            reactionId: resolvedReactionId,
          ),
        );
      },
    );
  }

  Future<void> _performRemoveReaction({
    required String postId,
    required ReactionType oldReaction,
    required int oldCount,
    String? oldReactionId,
  }) async {
    final result = await removeReactionFromPostUseCase(postId: postId);

    result.fold(
      (failure) {
        emit(
          ReactToPostError(
            postId: postId,
            message: failure.message,
            errorType: 'server',
            oldReactionType: oldReaction,
            oldCount: oldCount,
            oldReactionId: oldReactionId,
          ),
        );
      },
      (_) {
        _reactionIdsByPost.remove(postId);
        emit(
          ReactToPostSuccess(
            postId: postId,
            reactionType: ReactionType.none,
            reactionId: null,
          ),
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
      (failure) =>
          emit(ReportPostError(postId: postId, message: failure.message)),
      (_) => emit(ReportPostSuccess(postId: postId)),
    );
  }

  void resetState() {
    emit(PostInteractionInitial());
  }
}
