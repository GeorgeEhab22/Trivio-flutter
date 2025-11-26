part of 'create_post_cubit.dart';

sealed class CreatePostState extends Equatable {
  const CreatePostState();

  @override
  List<Object?> get props => [];
}

class CreatePostInitial extends CreatePostState {
  const CreatePostInitial();
}
class CreatePostLoading extends CreatePostState {
  const CreatePostLoading();
}
class CreatePostSuccess extends CreatePostState {
  final Post? createdPost;
  const CreatePostSuccess({ this.createdPost});
  @override
  List<Object> get props => [createdPost ?? Object()];
}
class CreatePostError extends CreatePostState {
  final String message;
  final String? errorType;
  const CreatePostError({required this.message, this.errorType});

@override
  List<Object?> get props => [message, errorType];

  bool get isValidationError => errorType == 'validation';
  bool get isNetworkError => errorType == 'network';

  
}

