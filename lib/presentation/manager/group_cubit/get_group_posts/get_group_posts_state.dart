import 'package:equatable/equatable.dart';
import 'package:auth/domain/entities/post.dart';

abstract class GetGroupPostsState extends Equatable {
  const GetGroupPostsState();

  @override
  List<Object?> get props => [];
}

class GetGroupPostsInitial extends GetGroupPostsState {}

class GetGroupPostsLoading extends GetGroupPostsState {}

class GetGroupPostsLoaded extends GetGroupPostsState {
  final List<Post> posts;
  const GetGroupPostsLoaded(this.posts);

  @override
  List<Object?> get props => [posts];
}

class GetGroupPostsError extends GetGroupPostsState {
  final String message;
  const GetGroupPostsError(this.message);

  @override
  List<Object?> get props => [message];
}

class GetGroupPostsLoadingMore extends GetGroupPostsState {
  final List<Post> posts;
  const GetGroupPostsLoadingMore(this.posts);

  @override
  List<Object?> get props => [posts];
}
