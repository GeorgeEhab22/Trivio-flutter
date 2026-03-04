import 'package:equatable/equatable.dart';
import 'package:auth/domain/entities/post.dart'; 

abstract class LikedPostsState extends Equatable {
  const LikedPostsState();

  @override
  List<Object?> get props => [];
}

class LikedPostsInitial extends LikedPostsState {}

class LikedPostsLoading extends LikedPostsState {}

class LikedPostsLoaded extends LikedPostsState {
  final List<Post> posts;

  const LikedPostsLoaded(this.posts);

  @override
  List<Object?> get props => [posts];
}

class LikedPostsError extends LikedPostsState {
  final String message;

  const LikedPostsError(this.message);

  @override
  List<Object?> get props => [message];
}