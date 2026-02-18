import 'package:equatable/equatable.dart';
import 'package:auth/domain/entities/post.dart';

abstract class GroupPostsState extends Equatable {
  const GroupPostsState();

  @override
  List<Object?> get props => [];
}

class GroupPostsInitial extends GroupPostsState {}

class GroupPostsLoading extends GroupPostsState {}

class GroupPostsLoaded extends GroupPostsState {
  final List<Post> posts;
  const GroupPostsLoaded(this.posts);

  @override
  List<Object?> get props => [posts];
}

class GroupPostsError extends GroupPostsState {
  final String message;
  const GroupPostsError(this.message);

  @override
  List<Object?> get props => [message];
}

class GroupPostsLoadingMore extends GroupPostsState {
  final List<Post> posts;
  const GroupPostsLoadingMore(this.posts);

  @override
  List<Object?> get props => [posts];
}

class GroupPostsDeleting extends GroupPostsState {
  final String postId;
  const GroupPostsDeleting({required this.postId});

  @override
  List<Object> get props => [postId];
}
