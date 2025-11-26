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

  const PostLoaded( this.posts);

  @override
  List<Object?> get props => [posts];
}

class PostsLoadingMore extends PostState {
  final List<Post> posts;

  const PostsLoadingMore( this.posts);

  @override
  List<Object?> get props => [posts];
}
class PostsSingleLoaded extends PostState {
  final Post post;

  const PostsSingleLoaded( this.post);

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

  const PostError( this.message);

  @override
  List<Object?> get props => [message];
}

