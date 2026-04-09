import 'package:equatable/equatable.dart';
import 'package:auth/domain/entities/post.dart';

abstract class GetUserPostsState extends Equatable {
  const GetUserPostsState();

  @override
  List<Object?> get props => [];
}

class GetUserPostsInitial extends GetUserPostsState {}

class GetUserPostsLoading extends GetUserPostsState {}

class GetUserPostsLoaded extends GetUserPostsState {
  final List<Post> posts;
  const GetUserPostsLoaded(this.posts);

  @override
  List<Object?> get props => [posts];
}

class GetUserPostsError extends GetUserPostsState {
  final String message;
  const GetUserPostsError(this.message);

  @override
  List<Object?> get props => [message];
}