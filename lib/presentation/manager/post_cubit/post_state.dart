part of 'post_cubit.dart';

sealed class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

class PostInitial extends PostState {
  const PostInitial();
}

class PostLoading extends PostState {
  const PostLoading();
}

class PostLoaded extends PostState {
  final List<Post> posts;
  final bool hasReachedMax; // Added to track pagination end

  const PostLoaded(this.posts, {this.hasReachedMax = false});

  @override
  List<Object?> get props => [posts, hasReachedMax];
}

class PostsLoadingMore extends PostState {
  final List<Post> posts;

  const PostsLoadingMore(this.posts);

  @override
  List<Object?> get props => [posts];
}

class PostsSingleLoaded extends PostState {
  final Post post;

  const PostsSingleLoaded(this.post);

  @override
  List<Object?> get props => [post];
}

class PostsLoadingMoreError extends PostState {
  final String message;
  final List<Post> posts;

  const PostsLoadingMoreError(this.message, this.posts);

  @override
  List<Object?> get props => [message, posts];
}

class PostError extends PostState {
  final String message;

  const PostError(this.message);

  @override
  List<Object?> get props => [message];
}

class EditPostLoading extends PostState {
  final String postId;
  const EditPostLoading({required this.postId});
}

class EditPostSuccess extends PostState {
  final Post updatedPost;
  const EditPostSuccess({required this.updatedPost});
  @override
  List<Object> get props => [updatedPost];
}

class EditPostError extends PostState {
  final String postId;
  final String message;
  const EditPostError({required this.postId, required this.message});
  @override
  List<Object> get props => [postId, message];
}

class DeletePostLoading extends PostState {
  final String postId;
  const DeletePostLoading({required this.postId});

  @override
  List<Object> get props => [postId];
}

class DeletePostSuccess extends PostState {
  final Post post;
  const DeletePostSuccess({required this.post});

  @override
  List<Object> get props => [post];
}

class DeletePostError extends PostState {
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