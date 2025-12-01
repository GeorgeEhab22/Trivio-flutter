part of 'post_interaction_cubit.dart';

sealed class PostInteractionState extends Equatable {
  const PostInteractionState();

  @override
  List<Object?> get props => [];

  ReactionType get reactionType => ReactionType.none;
}

class PostInteractionInitial extends PostInteractionState {}

// react to post
class ReactToPostLoading extends PostInteractionState {
  final String postId;
  const ReactToPostLoading({required this.postId});
}

class PostReactionUpdated extends PostInteractionState {
  final ReactionType reactionType;
  final int count;
  const PostReactionUpdated({required this.reactionType, required this.count});
  
  @override
  List<Object> get props => [reactionType, count];
}

class ReactToPostSuccess extends PostInteractionState {
  final String postId;
  final ReactionType reactionType;
  const ReactToPostSuccess({required this.postId, required this.reactionType});
}

class ReactToPostError extends PostInteractionState {
  final String postId;
  final String message;
  final String errorType;
  final ReactionType? oldReactionType; 
  final int? oldCount;

  const ReactToPostError({
    required this.postId, 
    required this.message, 
    required this.errorType,
    this.oldReactionType,
    this.oldCount,
  });

  @override
  List<Object?> get props => [postId, message, errorType, oldReactionType, oldCount];
}

// remove reaction from post

// delete post
class DeletePostLoading extends PostInteractionState {
  final String postId;
  const DeletePostLoading({required this.postId});

  @override
  List<Object> get props => [postId];
}

class DeletePostSuccess extends PostInteractionState {
  final Post post;
  const DeletePostSuccess({required this.post});

  @override
  List<Object> get props => [post];
}

class DeletePostError extends PostInteractionState {
  final String postId;
  final String message;
  final String? errorType;

  const DeletePostError({
    required this.postId,
    required this.message,
    this.errorType,
  });

  @override
  List<Object?> get props => [postId, message, errorType];

  bool get isValidationError => errorType == 'validation';
  bool get isNetworkError => errorType == 'network';
}

// share post

// share post states
class SharePostLoading extends PostInteractionState {
  final String postId;
  const SharePostLoading({required this.postId});

  @override
  List<Object> get props => [postId];
}

class SharePostSuccess extends PostInteractionState {
  final Post post;
  const SharePostSuccess({required this.post});

  @override
  List<Object> get props => [post];
}

class SharePostError extends PostInteractionState {
  final String postId;
  final String message;
  final String? errorType;

  const SharePostError({
    required this.postId,
    required this.message,
    this.errorType,
  });

  @override
  List<Object?> get props => [postId, message, errorType];

  bool get isValidationError => errorType == 'validation';
  bool get isNetworkError => errorType == 'network';
}
