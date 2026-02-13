import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/group.dart';
import 'package:auth/domain/usecases/group/groups/edit_group_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/update_group/update_group_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class UpdateGroupCubit extends Cubit<UpdateGroupState> {
  final UpdateGroupUseCase _updateGroupUseCase;

  final nameController = TextEditingController();
  final descController = TextEditingController();
  XFile? groupCoverImage;

  UpdateGroupCubit({required UpdateGroupUseCase updateGroupUseCase})
      : _updateGroupUseCase = updateGroupUseCase,
        super(const UpdateGroupInitial());

  void setInitialData(Group group) {
    nameController.text = group.groupName;
    descController.text = group.groupDescription;
    emit(const UpdateGroupInitial());
  }

  Future<void> updateGroup(String groupId) async {
    if (!validateFields()) return;

    emit(const UpdateGroupLoading());

    final result = await _updateGroupUseCase(
      groupId: groupId,
      name: nameController.text.trim(),
      description: descController.text.trim(),
      coverImage: groupCoverImage?.path, 
    );

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (group) => emit(UpdateGroupSuccess(group: group)),
    );
  }

  void updateImage(XFile file) {
    groupCoverImage = file;
    emit(UpdateGroupInitial(groupCoverImage: file));
  }

  bool validateFields() {
    String? nameErr;
    String? descErr;
    if (nameController.text.trim().isEmpty) nameErr = "Name cannot be empty";
    if (descController.text.trim().isEmpty) descErr = "Description is required";

    emit(UpdateGroupInitial(nameError: nameErr, descError: descErr));
    return nameErr == null && descErr == null;
  }

  UpdateGroupFailure _mapFailureToState(Failure failure) {
    String type = 'server';
    if (failure is ValidationFailure) type = 'validation';
    if (failure is NetworkFailure) type = 'network';
    return UpdateGroupFailure(message: failure.message, errorType: type);
  }

  @override
  Future<void> close() {
    nameController.dispose();
    descController.dispose();
    return super.close();
  }
}