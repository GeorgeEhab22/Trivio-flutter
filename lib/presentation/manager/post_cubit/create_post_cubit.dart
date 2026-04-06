import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/tags.dart';
import 'package:auth/domain/usecases/face-recognition/auto_tagging_use_case.dart';
import 'package:auth/domain/usecases/group/group_posts/create_group_post_use_case.dart';
import 'package:auth/domain/usecases/post/create_post_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final CreatePostUseCase createPostUseCase;
  final CreateGroupPostUseCase createGroupPostUseCase;
  final AutoTaggingUseCase autoTaggingUseCase;

  List<XFile> _media = [];
  String type = "Public";
  String caption = "";

  List<bool> _isProcessing = [];
  List<Tags> _readyTags = [];
  List<Future<void>> _backgroundTasks = [];

  CreatePostCubit({
    required this.createPostUseCase,
    required this.createGroupPostUseCase,
    required this.autoTaggingUseCase,
  }) : super(const CreatePostInitial());

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
    for (var file in files) {
      _media.add(file);
      _isProcessing.add(true);

      final int currentIndex = _media.length - 1;

      final task = autoTaggingUseCase
          .call(file)
          .then((result) {
            if (isClosed) return;

            result.fold(
              (failure) {
                _isProcessing[currentIndex] = false;
                _emitEditingState();
              },
              (tags) {
                if (tags.isNotEmpty) {
                  _readyTags.addAll(tags);
                  _readyTags = _readyTags.toSet().toList();
                }
                _isProcessing[currentIndex] = false;
                _emitEditingState();
              },
            );
          })
          .catchError((error) {
            if (!isClosed) {
              _isProcessing[currentIndex] = false;
              _emitEditingState();
            }
          });

      _backgroundTasks.add(task);
    }
    _emitEditingState();
  }

  void removeMedia(int index) {
    if (index < 0 || index >= _media.length) return;
    _media.removeAt(index);
    _isProcessing.removeAt(index);
    _emitEditingState();
  }

  void updatePrivacy(String newPrivacy) {
    type = newPrivacy;
    _emitEditingState();
  }

  void _emitEditingState() {
    final bool isAnyImageProcessing = _isProcessing.contains(true);
    final bool isEnabled =
        (caption.trim().isNotEmpty || _media.isNotEmpty) &&
        !isAnyImageProcessing;
    emit(
      CreatePostEditing(
        selectedMedia: List.from(_media),
        privacy: type,
        isPostButtonEnabled: isEnabled,
        lastUpdated: DateTime.now().toIso8601String(),
        isProcessing: List.from(_isProcessing),
      ),
    );
  }

  void resetState() {
    _resetForm();
    emit(const CreatePostInitial());
  }

  void _resetForm() {
    _media = [];
    caption = "";
    type = "Public";
    _isProcessing = [];
    _readyTags = [];
    _backgroundTasks = [];
  }

  // --- Submission Logic ---

  Future<void> submitPost({required String userId, String? groupId}) async {
    if (caption.trim().isEmpty && _media.isEmpty) return;

    emit(const CreatePostLoading());

    List<String> tagsToBackend = [];
    for (var tag in _readyTags) {
      if (tag.enName.isNotEmpty) tagsToBackend.add(tag.enName);
      if (tag.arName.isNotEmpty) tagsToBackend.add(tag.arName);
    }
    tagsToBackend = tagsToBackend.toSet().toList();

    bool shownTags = false;
    for (var tag in _readyTags) {
      String uiEnTag = tag.enName.isNotEmpty
          ? '#${tag.enName.replaceAll(' ', '_')}'
          : '';
      String uiArTag = tag.arName.isNotEmpty
          ? '#${tag.arName.replaceAll(' ', '_')}'
          : '';

      if ((uiEnTag.isNotEmpty && caption.contains(uiEnTag)) ||
          (uiArTag.isNotEmpty && caption.contains(uiArTag))) {
        shownTags = true;
        break;
      }
    }

    final result = (groupId != null)
        ? await createGroupPostUseCase(
            groupId: groupId,
            caption: caption,
            media: _media,
            type: "public",
            tags: tagsToBackend,
            shownTags: shownTags,
          )
        : await createPostUseCase(
            caption: caption,
            media: _media,
            type: type,
            tags: tagsToBackend,
            shownTags: shownTags,
          );

    if (isClosed) return;
    result.fold((failure) => emit(_mapFailureToState(failure)), (createdPost) {
      emit(CreatePostSuccess(createdPost: createdPost));
      _resetForm();
    });
  }

  CreatePostError _mapFailureToState(Failure failure) {
    if (failure is ValidationFailure) {
      return CreatePostError(message: failure.message, errorType: 'validation');
    } else if (failure is NetworkFailure) {
      return CreatePostError(message: failure.message, errorType: 'network');
    } else {
      return CreatePostError(message: failure.message, errorType: 'server');
    }
  }

  void triggerHashtagsEffect(void Function() onEffectFinished) {
    if (_media.isEmpty) {
      onEffectFinished();
      return;
    }

    _isProcessing = List.generate(_media.length, (_) => true);
    _emitEditingState();

    final minDelayTask = Future.delayed(const Duration(milliseconds: 500));

    Future finalWait;

    if (_backgroundTasks.isNotEmpty) {
      finalWait = Future.wait([..._backgroundTasks, minDelayTask]);
    } else {
      finalWait = minDelayTask;
    }

    finalWait.then((_) {
      if (isClosed) return;

      _isProcessing = List.generate(_media.length, (_) => false);
      _emitEditingState();

      onEffectFinished();

      _backgroundTasks.clear();
    });
  }

  String buildFinalPostText(String currentText) {
    if (_readyTags.isEmpty) return currentText;

    String cleanedText = currentText;

    
    for (var tag in _readyTags) {
      if (tag.enName.isNotEmpty) {
        String enTag = '#${tag.enName.replaceAll(' ', '_')}';
        cleanedText = cleanedText.replaceAll(enTag, '');
      }
      if (tag.arName.isNotEmpty) {
        String arTag = '#${tag.arName.replaceAll(' ', '_')}';
        cleanedText = cleanedText.replaceAll(arTag, '');
      }
    }

    cleanedText = cleanedText.trim();

    List<String> englishTags = [];
    List<String> arabicTags = [];

    for (var tag in _readyTags) {
      if (tag.enName.isNotEmpty) {
        englishTags.add('#${tag.enName.replaceAll(' ', '_')}');
      }
      if (tag.arName.isNotEmpty) {
        arabicTags.add('#${tag.arName.replaceAll(' ', '_')}');
      }
    }

    englishTags = englishTags.toSet().toList();
    arabicTags = arabicTags.toSet().toList();

    String formattedTags = '';
    
    if (englishTags.isNotEmpty) {
      formattedTags += englishTags.join(' ');
    }
    
    if (arabicTags.isNotEmpty) {
      formattedTags +=
          (formattedTags.isNotEmpty ? '\n' : '') + arabicTags.join(' ');
    }

    if (cleanedText.isEmpty) {
      return formattedTags;
    } else {
      return "$cleanedText\n\n$formattedTags";
    }
  }
}
