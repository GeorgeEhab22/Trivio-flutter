import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/usecases/post/create_post_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final CreatePostUseCase createPostUseCase;

  CreatePostCubit({required this.createPostUseCase})
    : super(CreatePostInitial());

  Future<void> createPost({
    required String userId,
    String? content,
    String? imageUrl,
    String? videoUrl,
    List<String>? tags,
  }) async {
    emit(const CreatePostLoading());
    final result = await createPostUseCase(
      userId: userId,
      content: content,
      imageUrl: imageUrl,
      videoUrl: videoUrl,
      tags: tags,
    );
    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (createdPost) => emit(CreatePostSuccess(createdPost: createdPost)),
    );
  }

  CreatePostError _mapFailureToState(Failure failure) {
    switch (failure.runtimeType) {
      case const(ValidationFailure):
        return CreatePostError(
          message: failure.message,
          errorType: 'validation',
        );
      case const(NetworkFailure):
        return CreatePostError(message: failure.message, errorType: 'network');
      default:
        return CreatePostError(message: failure.message, errorType: 'server');
    }
  }

  void resetState() => emit(const CreatePostInitial());

  bool get isLoading => state is CreatePostLoading;
  bool get isSuccess => state is CreatePostSuccess;
  bool get isFailure => state is CreatePostError;
  bool get isInitial => state is CreatePostInitial;

  Post? get createdPost => 
  state is CreatePostSuccess ? (state as CreatePostSuccess).createdPost : null;
  String? get errorMessage =>
      state is CreatePostError ? (state as CreatePostError).message : null;
}
