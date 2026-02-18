import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/usecases/group/group_posts/create_group_post_use_case.dart';
import 'package:auth/domain/usecases/post/create_post_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final CreatePostUseCase createPostUseCase;
  final CreateGroupPostUseCase createGroupPostUseCase;

  List<XFile> _media = [];
  String type = "Public";
  String caption = "";

  CreatePostCubit({required this.createPostUseCase,required this.createGroupPostUseCase})
      : super(const CreatePostInitial());

  // --- UI Helpers ---

  bool get isLoading => state is CreatePostLoading;
  bool get isSuccess => state is CreatePostSuccess;
  List<XFile> get currentMedia => _media;
  String get currentPrivacy => type;

  // --- Event Handlers ---

  void updateText(String text) {
    caption = text;
    _emitEditingState();
  }

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
    type = newPrivacy;
    _emitEditingState();
  }

  void _emitEditingState() {
    // Enable button if there is text OR media
    final bool isEnabled = caption.trim().isNotEmpty || _media.isNotEmpty;

    emit(CreatePostEditing(
      selectedMedia: List.from(_media),
      privacy: type,
      isPostButtonEnabled: isEnabled,
      lastUpdated: DateTime.now().toIso8601String(),
    ));
  }

  void resetState() {
    _resetForm();
    emit(const CreatePostInitial());
  }

  void _resetForm() {
    _media = [];
    caption = "";
    type = "Public";
  }

  // --- Submission Logic ---

  Future<void> submitPost({required String userId,String? groupId}) async {
    if (caption.trim().isEmpty && _media.isEmpty) return;

    emit(const CreatePostLoading());

   
    final result = (groupId != null)
        ? await createGroupPostUseCase(
            groupId: groupId,
            caption: caption,
            media: _media,
            type: "private",
          )
        : await createPostUseCase(
            caption: caption,
            media: _media,
            type: type,
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
      return CreatePostError(
          message: failure.message, errorType: 'network');
    } else {
      return CreatePostError(
          message: failure.message, errorType: 'server');
    }
  }
}