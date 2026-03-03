import 'package:equatable/equatable.dart';
import 'package:auth/domain/entities/post.dart';

sealed class GroupPostsState extends Equatable {
  const GroupPostsState();

  @override
  List<Object?> get props => [];
}

class GroupPostsInitial extends GroupPostsState {
  const GroupPostsInitial();
}

class GroupPostsLoading extends GroupPostsState {
  const GroupPostsLoading();
}

class GroupPostsLoaded extends GroupPostsState {
  final List<Post> posts;
  final bool hasReachedMax;

  const GroupPostsLoaded(this.posts, {this.hasReachedMax = false});

  @override
  List<Object?> get props => [posts, hasReachedMax];
}

class GroupPostsLoadingMore extends GroupPostsState {
  final List<Post> posts;
  const GroupPostsLoadingMore(this.posts);

  @override
  List<Object?> get props => [posts];
}

class GroupPostsLoadingMoreError extends GroupPostsState {
  final String message;
  final List<Post> posts;

  const GroupPostsLoadingMoreError(this.message, this.posts);

  @override
  List<Object?> get props => [message, posts];
}

class GroupPostsSingleLoaded extends GroupPostsState {
  final Post post;
  const GroupPostsSingleLoaded(this.post);

  @override
  List<Object?> get props => [post];
}

class GroupPostsError extends GroupPostsState {
  final String message;
  const GroupPostsError(this.message);

  @override
  List<Object?> get props => [message];
}

class GroupPostsEditing extends GroupPostsState {
  final String postId;
  const GroupPostsEditing({required this.postId});

  @override
  List<Object> get props => [postId];
}

class GroupPostsEditSuccess extends GroupPostsState {
  final Post updatedPost;
  const GroupPostsEditSuccess({required this.updatedPost});

  @override
  List<Object> get props => [updatedPost];
}

class GroupPostsEditError extends GroupPostsState {
  final String postId;
  final String message;
  const GroupPostsEditError({required this.postId, required this.message});

  @override
  List<Object> get props => [postId, message];
}

class GroupPostsDeleting extends GroupPostsState {
  final String postId;
  const GroupPostsDeleting({required this.postId});

  @override
  List<Object> get props => [postId];
}

class GroupPostsDeleteSuccess extends GroupPostsState {
  final Post post;
  const GroupPostsDeleteSuccess({required this.post});

  @override
  List<Object> get props => [post];
}

class GroupPostsDeleteError extends GroupPostsState {
  final String postId;
  final String message;
  const GroupPostsDeleteError({required this.postId, required this.message});

  @override
  List<Object> get props => [postId, message];
}