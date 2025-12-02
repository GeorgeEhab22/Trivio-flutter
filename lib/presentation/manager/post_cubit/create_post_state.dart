part of 'create_post_cubit.dart';

sealed class CreatePostState extends Equatable {
  const CreatePostState();

  @override
  List<Object?> get props => [];
}

final class CreatePostInitial extends CreatePostState {
  const CreatePostInitial();
}

final class CreatePostEditing extends CreatePostState {
  final List<XFile> selectedMedia;
  final String privacy;
  final bool isPostButtonEnabled;
  final String lastUpdated; 

  const CreatePostEditing({
    this.selectedMedia = const [],
    this.privacy = "Public",
    this.isPostButtonEnabled = false,
    required this.lastUpdated,
  });

  @override
  List<Object> get props => [selectedMedia, privacy, isPostButtonEnabled, lastUpdated];
}

final class CreatePostLoading extends CreatePostState {
  const CreatePostLoading();
}

final class CreatePostSuccess extends CreatePostState {
  final Post? createdPost;
  const CreatePostSuccess({this.createdPost});
  
  @override
  List<Object> get props => [createdPost ?? Object()];
}

final class CreatePostError extends CreatePostState {
  final String message;
  final String? errorType;
  
  const CreatePostError({required this.message, this.errorType});

  @override
  List<Object?> get props => [message, errorType];

  bool get isValidationError => errorType == 'validation';
  bool get isNetworkError => errorType == 'network';
}