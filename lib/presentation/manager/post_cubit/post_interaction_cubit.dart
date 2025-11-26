import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/repositories/post_repo.dart';
import 'package:auth/domain/usecases/post/comment_on_post_usecase.dart';
import 'package:auth/domain/usecases/post/delete_post_usecase.dart';
import 'package:auth/domain/usecases/post/edit_post_usecase.dart';
import 'package:auth/domain/usecases/post/react_to_post_usecase.dart';
import 'package:auth/domain/usecases/post/remove_reaction_from_post_usecase.dart';
import 'package:auth/domain/usecases/post/report_post_usecase.dart';
import 'package:auth/domain/usecases/post/share_post_usecase.dart';
import 'package:auth/domain/usecases/post/toggle_follow_user.dart';
import 'package:auth/domain/usecases/post/toggle_save_post_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'post_interaction_state.dart';

class PostInteractionCubit extends Cubit<PostInteractionState> {
  final ReactToPostUseCase reactToPostUseCase;
  final RemoveReactionFromPostUseCase removeReactionFromPostUseCase;
  final CommentOnPostUseCase commentOnPostUseCase;
  final DeletePostUseCase deletePostUseCase;
  final EditPostUseCase editPostUseCase;
  final ReportPostUseCase reportPostUseCase;
  final SharePostUseCase sharePostUseCase;
  final ToggleSavePostUseCase toggleSavePostUseCase;
  final ToggleFollowUserUseCase toggleFollowUserUseCase;

  PostInteractionCubit({
    required this.reactToPostUseCase,
    required this.removeReactionFromPostUseCase,
    required this.commentOnPostUseCase,
    required this.deletePostUseCase,
    required this.editPostUseCase,
    required this.reportPostUseCase,
    required this.sharePostUseCase,
    required this.toggleSavePostUseCase,
    required this.toggleFollowUserUseCase,
  }) : super(PostInteractionInitial());

  // react to post
  Future<void> reactToPost({
    required String postId,
    required String userId,
    required ReactionType reactionType,
  }) async {
    emit(ReactToPostLoading(postId: postId));

    final result = await reactToPostUseCase(
      postId: postId,
      userId: userId,
      reactionType: reactionType,
    );

    result.fold((failure) => emit(_mapFailureToState(failure, postId)), (post) {
      emit(ReactToPostSuccess(postId: post.id, reactionType: reactionType));
    });
  }

  ReactToPostError _mapFailureToState(Failure failure, String postId) {
    switch (failure.runtimeType) {
      case const (ValidationFailure):
        return ReactToPostError(
          postId: postId,
          message: failure.message,
          errorType: 'validation',
        );
      case const (NetworkFailure):
        return ReactToPostError(
          postId: postId,
          message: failure.message,
          errorType: 'network',
        );
      default:
        return ReactToPostError(
          postId: postId,
          message: failure.message,
          errorType: 'server',
        );
    }
  }

  void resetState() => emit(PostInteractionInitial());

  bool get isLoading => state is ReactToPostLoading;
  bool get isSuccess => state is ReactToPostSuccess;
  bool get isFailure => state is ReactToPostError;
  bool get isInitial => state is PostInteractionInitial;

  ReactionType? get currentUser => state is ReactToPostSuccess
      ? (state as ReactToPostSuccess).reactionType
      : null;

  String? get errorMessage =>
      state is ReactToPostError ? (state as ReactToPostError).message : null;

  // delete post
  Future<void> deletePost({required Post post}) async {
    emit(DeletePostLoading(postId: post.id));

    final result = await deletePostUseCase(post.id);

    result.fold(
      (failure) => emit(_mapDeleteFailureToState(failure, post.id)),
      (_) => emit(DeletePostSuccess(post: post)),
    );
  }

  DeletePostError _mapDeleteFailureToState(Failure failure, String postId) {
    switch (failure.runtimeType) {
      case const (ValidationFailure):
        return DeletePostError(
          postId: postId,
          message: failure.message,
          errorType: 'validation',
        );
      case const (NetworkFailure):
        return DeletePostError(
          postId: postId,
          message: failure.message,
          errorType: 'network',
        );
      default:
        return DeletePostError(
          postId: postId,
          message: failure.message,
          errorType: 'server',
        );
    }
  }

  void resetDeleteState() => emit(PostInteractionInitial());
  bool get isDeleteLoading => state is DeletePostLoading;
  bool get isDeleteSuccess => state is DeletePostSuccess;
  bool get isDeleteFailure => state is DeletePostError;
  bool get isDeleteInitial => state is PostInteractionInitial;

  String? get deleteErrorMessage =>
      state is DeletePostError ? (state as DeletePostError).message : null;

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
}
