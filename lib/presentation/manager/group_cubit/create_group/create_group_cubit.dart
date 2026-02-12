import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/usecases/group/groups/create_group_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/create_group/create_group_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CreateGroupCubit extends Cubit<CreateGroupState> {
  final CreateGroupUseCase _createGroupUseCase;

  final nameController = TextEditingController();
  final descController = TextEditingController();
  XFile? groupCoverImage;

  CreateGroupCubit({required CreateGroupUseCase createGroupUseCase})
    : _createGroupUseCase = createGroupUseCase,
      super(CreateGroupInitial());

  Future<void> createGroup() async {
    if (nameController.text.trim().isEmpty) {
      emit(
        const CreateGroupFailure(
          message: "Name is required",
          errorType: "validation",
        ),
      );
      return;
    }

    emit(const CreateGroupLoading());

    final result = await _createGroupUseCase(
      name: nameController.text.trim(),
      description: descController.text.trim(),
      coverImage: groupCoverImage,
    );

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (group) => emit(const CreateGroupSuccess()),
    );
  }

  @override
  Future<void> close() {
    nameController.dispose();
    descController.dispose();
    return super.close();
  }

  void updateImage(XFile file) {
    groupCoverImage = file;
    emit(CreateGroupInitial());
  }

  bool validateFields() {
    String? nameErr;
    String? descErr;

    if (nameController.text.trim().isEmpty) {
      nameErr = "Write your group name";
    }
    if (descController.text.trim().isEmpty) {
      descErr = "Descripe your group";
    }

    emit(CreateGroupInitial(nameError: nameErr, descError: descErr));

    return nameErr == null && descErr == null;
  }

  void clearFieldsError() {
    if (state is CreateGroupInitial) {
      final currentState = state as CreateGroupInitial;
      if (currentState.nameError != null || currentState.descError != null) {
        emit(const CreateGroupInitial());
      }
    }
  }

  CreateGroupFailure _mapFailureToState(Failure failure) {
    switch (failure.runtimeType) {
      case const (ValidationFailure):
        return CreateGroupFailure(
          message: failure.message,
          errorType: 'validation',
        );
      case const (NetworkFailure):
        return CreateGroupFailure(
          message: failure.message,
          errorType: 'network',
        );
      default:
        return CreateGroupFailure(
          message: failure.message,
          errorType: 'server',
        );
    }
  }

  void resetState() => emit(const CreateGroupInitial());

  bool get isLoading => state is CreateGroupLoading;
  bool get isSuccess => state is CreateGroupSuccess;
  bool get isFailure => state is CreateGroupFailure;
}
