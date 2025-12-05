
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

  /// Add picked media (no validation here — validation will be done in the use case)
  void addMedia(List<XFile> files) {
    _media.addAll(files);
    _emitEditingState();
  }

  void removeMedia(int index) {
    if (index < 0 || index >= _media.length) return;
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

  /// Submit post — split media into images and videos, then pass them to the use case.
  Future<void> submitPost({required String userId}) async {
    if (_text.trim().isEmpty && _media.isEmpty) return;

    emit(const CreatePostLoading());

    // classify media by extension
    final imageExts = <String>{
      'jpg', 'jpeg', 'png', 'gif', 'webp', 'heic', 'heif', 'bmp'
    };
    final videoExts = <String>{
      'mp4', 'mov', 'avi', 'mkv', 'flv', 'webm', 'm4v', '3gp'
    };

    List<XFile> imageFiles = [];
    List<XFile> videoFiles = [];

    for (final xfile in _media) {
      final path = xfile.path;
      final ext = _extractExtension(path);

      if (ext.isEmpty) {
        // unknown: you can choose to treat as image or skip; here we skip
        continue;
      }

      if (imageExts.contains(ext)) {
        imageFiles.add(xfile);
      } else if (videoExts.contains(ext)) {
        videoFiles.add(xfile);
      } else {
        // unknown extension: skip (leave validation/uploading to use case)
      }
    }

    
    final result = await createPostUseCase(
      userId: userId,
      content: _text,
      media: _media,  
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
    if (failure is ValidationFailure) {
      return CreatePostError(
        message: failure.message,
        errorType: 'validation',
      );
    } else if (failure is NetworkFailure) {
      return CreatePostError(message: failure.message, errorType: 'network');
    } else {
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

  bool get isLoading => state is CreatePostLoading;
  bool get isSuccess => state is CreatePostSuccess;

  List<XFile> get currentMedia => _media;
  String get currentPrivacy => _privacy;

  // Helper: extract lowercase extension without leading dot, or empty string
  static String _extractExtension(String path) {
    try {
      final parts = path.split('.');
      if (parts.length < 2) return '';
      return parts.last.toLowerCase();
    } catch (_) {
      return '';
    }
  }
}
