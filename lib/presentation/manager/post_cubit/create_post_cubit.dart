import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/usecases/post/create_post_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final CreatePostUseCase createPostUseCase;

  List<XFile> _media = [];
  String _privacy = "Public";
  String _text = "";

  CreatePostCubit({required this.createPostUseCase})
      : super(const CreatePostInitial());


  void updateText(String text) {
    _text = text;
    _emitEditingState();
  }

  void addMedia(List<XFile> files) {
    _media.addAll(files);
    _emitEditingState();
  }

  void removeMedia(int index) {
    _media.removeAt(index);
    _emitEditingState();
  }

  void updatePrivacy(String newPrivacy) {
    _privacy = newPrivacy;
    _emitEditingState();
  }

  void _emitEditingState() {
    final bool isEnabled = _text.trim().isNotEmpty || _media.isNotEmpty;
    
    emit(CreatePostEditing(
      selectedMedia: List.from(_media),
      privacy: _privacy,
      isPostButtonEnabled: isEnabled,
      lastUpdated: DateTime.now().toIso8601String(),
    ));
  }


  Future<void> submitPost({required String userId}) async {
    if (_text.trim().isEmpty && _media.isEmpty) return;

    emit(const CreatePostLoading());

    
    String? imageUrl;
    String? videoUrl;

    if (_media.isNotEmpty) {

       if (_media.first.path.endsWith('.mp4')) {
          videoUrl = _media.first.path; 
       } else {
          imageUrl = _media.first.path;
       }
    }

    final result = await createPostUseCase(
      userId: userId,
      content: _text,
      imageUrl: imageUrl, 
      videoUrl: videoUrl,
      tags: [],
    );

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (createdPost) {
        emit(CreatePostSuccess(createdPost: createdPost));
        _resetForm();
      },
    );
  }

  CreatePostError _mapFailureToState(Failure failure) {
    switch (failure.runtimeType) {
      case const (ValidationFailure):
        return CreatePostError(
          message: failure.message,
          errorType: 'validation',
        );
      case const (NetworkFailure):
        return CreatePostError(message: failure.message, errorType: 'network');
      default:
        return CreatePostError(message: failure.message, errorType: 'server');
    }
  }

  void _resetForm() {
    _media = [];
    _text = "";
    _privacy = "Public";
  }

  void resetState() {
    _resetForm();
    emit(const CreatePostInitial());
  }

  // Getters for UI convenience
  bool get isLoading => state is CreatePostLoading;
  bool get isSuccess => state is CreatePostSuccess;
  
  List<XFile> get currentMedia => _media;
  String get currentPrivacy => _privacy;
}