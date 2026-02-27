import 'package:auth/domain/entities/comment.dart';
import 'package:equatable/equatable.dart';

sealed class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object?> get props => [];
}

final class CommentInitial extends CommentState {}

final class CommentLoading extends CommentState {
  final List<Comment> comments;
  const CommentLoading(this.comments);

  @override
  List<Object> get props => [comments];
}

final class CommentLoaded extends CommentState {
  final List<Comment> comments;
  final bool isRefetching;
  final Comment? replyingToComment;
  final Set<String> expandedReplyParentIds;
  final Set<String> loadingReplyParentIds;

  const CommentLoaded(
    this.comments, {
    this.isRefetching = false,
    this.replyingToComment,
    this.expandedReplyParentIds = const <String>{},
    this.loadingReplyParentIds = const <String>{},
  });

  @override
  List<Object?> get props => [
    comments,
    isRefetching,
    replyingToComment,
    expandedReplyParentIds,
    loadingReplyParentIds,
  ];
}

final class CommentError extends CommentState {
  final String message;
  const CommentError(this.message);

  @override
  List<Object> get props => [message];
}

final class CommentReplyState extends CommentState {
  final Comment replyingToComment;
  const CommentReplyState(this.replyingToComment);

  @override
  List<Object> get props => [replyingToComment];
}

final class CommentEditState extends CommentState {
  final Comment commentToEdit;
  const CommentEditState(this.commentToEdit);

  @override
  List<Object> get props => [commentToEdit];
}

final class CommentNormalState extends CommentState {}

final class CommentActionLoading extends CommentState {}

final class CommentActionSuccess extends CommentState {
  final String message;
  const CommentActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class CommentActionError extends CommentState {
  final String message;
  const CommentActionError(this.message);

  @override
  List<Object> get props => [message];
}
