import 'package:equatable/equatable.dart';
import 'package:auth/domain/entities/post.dart';

abstract class SavedPostsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SavedPostsInitial extends SavedPostsState {}

class SavedPostsLoading extends SavedPostsState {}

class SavedPostsLoaded extends SavedPostsState {
  final List<Post> savedPosts;
  SavedPostsLoaded(this.savedPosts);

  @override
  List<Object?> get props => [savedPosts];
}

class SavedPostsError extends SavedPostsState {
  final String message;
  SavedPostsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Optional: State for the specific action of saving/unsaving
class SavedPostActionSuccess extends SavedPostsState {}