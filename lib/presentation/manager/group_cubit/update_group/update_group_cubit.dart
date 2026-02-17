import 'package:auth/domain/entities/group.dart';
import 'package:auth/domain/usecases/group/groups/edit_group_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/update_group/update_group_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class UpdateGroupCubit extends Cubit<UpdateGroupState> {
  final UpdateGroupUseCase _updateGroupUseCase;

  String? name;
  String? description;
  XFile? groupCoverImage;

  UpdateGroupCubit({required UpdateGroupUseCase updateGroupUseCase})
    : _updateGroupUseCase = updateGroupUseCase,
      super(const UpdateGroupInitial());

  void setInitialData(Group group) {
    name = group.groupName;
    description = group.groupDescription;
  }

  void updateName(String newName) => name = newName;
  void updateDescription(String newDesc) => description = newDesc;
  void updateImage(XFile file) {
    groupCoverImage = file;
    emit(UpdateGroupInitial(groupCoverImage: file));
  }

  Future<void> updateGroup({required String groupId}) async {
    emit(const UpdateGroupLoading());

    ////////////////////////////
    //TODO: untill the issue is fixed with backend
    String? finalDesc = description?.trim();
    if (finalDesc != null && finalDesc.isEmpty) {
      finalDesc = " not empty ";
    }
    ////////////////////////////
    
    final result = await _updateGroupUseCase(
      groupId: groupId,
      name: name?.trim(),
      description: finalDesc,
      coverImage: groupCoverImage,
    );
    result.fold(
      (failure) => emit(UpdateGroupFailure(message: failure.message)),
      (group) {
        groupCoverImage = null;
        emit(UpdateGroupSuccess(group: group));
      },
    );
  }
}
