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
  final String postId;
  @override
  final ReactionType reactionType;
  final int count;
  final String? reactionId;
  const PostReactionUpdated({
    required this.postId,
    required this.reactionType,
    required this.count,
    this.reactionId,
  });
  
  @override
  List<Object?> get props => [postId, reactionType, count, reactionId];
}

class ReactToPostSuccess extends PostInteractionState {
  final String postId;
  @override
  final ReactionType reactionType;
  final String? reactionId;
  const ReactToPostSuccess({
    required this.postId,
    required this.reactionType,
    this.reactionId,
  });

  @override
  List<Object?> get props => [postId, reactionType, reactionId];
}

class ReactToPostError extends PostInteractionState {
  final String postId;
  final String message;
  final String errorType;
  final ReactionType? oldReactionType; 
  final int? oldCount;
  final String? oldReactionId;

  const ReactToPostError({
    required this.postId, 
    required this.message, 
    required this.errorType,
    this.oldReactionType,
    this.oldCount,
    this.oldReactionId,
  });

  @override
  List<Object?> get props => [
    postId,
    message,
    errorType,
    oldReactionType,
    oldCount,
    oldReactionId,
  ];
}




// share post

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




// save post

class PostSaveUpdated extends PostInteractionState {
  final bool isSaved;
  const PostSaveUpdated({required this.isSaved});
  @override
  List<Object> get props => [isSaved];
}

class SavePostSuccess extends PostInteractionState {
  final String postId;
  final bool isSaved;
  const SavePostSuccess({required this.postId, required this.isSaved});
}

class SavePostError extends PostInteractionState {
  final String postId;
  final String message;
  final bool oldStatus;
  const SavePostError({required this.postId, required this.message, required this.oldStatus});
}

// follow user


class PostFollowUpdated extends PostInteractionState {
  final bool isFollowing;
  const PostFollowUpdated({required this.isFollowing});
  @override
  List<Object> get props => [isFollowing];
}

class FollowUserSuccess extends PostInteractionState {
  final String userId; // Followee ID
  final bool isFollowing;
  const FollowUserSuccess({required this.userId, required this.isFollowing});
}

class FollowUserError extends PostInteractionState {
  final String message;
  final bool oldStatus;
  const FollowUserError({required this.message, required this.oldStatus});
}






// report post


class ReportPostLoading extends PostInteractionState {
  final String postId;
  const ReportPostLoading({required this.postId});
}

class ReportPostSuccess extends PostInteractionState {
  final String postId;
  const ReportPostSuccess({required this.postId});

  @override
  List<Object> get props => [postId];
}

class ReportPostError extends PostInteractionState {
  final String postId;
  final String message;
  const ReportPostError({required this.postId, required this.message});

  @override
  List<Object> get props => [postId, message];
}
