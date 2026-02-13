import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/usecases/group/groups/delete_group_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/delete_group/delete_group_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteGroupCubit extends Cubit<DeleteGroupState> {
  final DeleteGroupUseCase _deleteGroupUseCase;

  DeleteGroupCubit({required DeleteGroupUseCase deleteGroupUseCase})
    : _deleteGroupUseCase = deleteGroupUseCase,
      super(DeleteGroupInitial());

  Future<void> deleteGroup(String groupId) async {
    emit(DeleteGroupLoading());

    final result = await _deleteGroupUseCase(groupId: groupId);

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (message) => emit(DeleteGroupSuccess(message)),
    );
  }

  DeleteGroupFailure _mapFailureToState(Failure failure) {
    String type = 'server';
    if (failure is NetworkFailure) type = 'network';
    return DeleteGroupFailure(message: failure.message, errorType: type);
  }
}
