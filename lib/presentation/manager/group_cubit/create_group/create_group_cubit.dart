import 'package:auth/domain/usecases/group/groups/create_group_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/create_group/create_group_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CreateGroupCubit extends Cubit<CreateGroupState> {
  final CreateGroupUseCase _createGroupUseCase;

  String? name;
  String? description;
  XFile? groupCoverImage;

  CreateGroupCubit({required CreateGroupUseCase createGroupUseCase})
    : _createGroupUseCase = createGroupUseCase,
      super(const CreateGroupInitial());

  void updateName(String val) => name = val;
  void updateDescription(String val) => description = val;

  void updateImage(XFile file) {
    groupCoverImage = file;
    emit(CreateGroupInitial(groupCoverImage: file));
  }

  bool validateFields() {
    String? nameErr;
    if (name?.trim().isEmpty ?? true) {
      nameErr = "Write your group name";
    }

    if (nameErr != null) {
      emit(CreateGroupInitial(nameError: nameErr));
      return false;
    }

    emit(const CreateGroupInitial());
    return true;
  }

  Future<void> createGroup() async {
    emit(const CreateGroupLoading());

    final result = await _createGroupUseCase(
      name: name?.trim()??"",
      description: description?.trim(),
      coverImage: groupCoverImage,
    );

    result.fold(
      (failure) => emit(CreateGroupFailure(message: failure.message)),
      (group) {
        emit(CreateGroupSuccess(group: group));
        resetForm();
      },
    );
  }

  void clearFieldsError() {
    if (state is CreateGroupInitial) {
      final currentState = state as CreateGroupInitial;
      if (currentState.nameError != null || currentState.descError != null) {
        emit(const CreateGroupInitial());
      }
    }
  }

  void resetForm() {
    name = null;
    description = null;
    groupCoverImage = null;
    emit(const CreateGroupInitial());
  }
}
