import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/usecases/group/groups/join_group_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/join_group/join_group_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JoinGroupCubit extends Cubit<JoinGroupState> {
  final JoinGroupUseCase _joinGroupUseCase;
  JoinGroupCubit({required JoinGroupUseCase joinGroupUseCase})
    : _joinGroupUseCase = joinGroupUseCase,
      super(const JoinGroupInitial());

  Future<void> joinGroup({required String groupId}) async {
    emit(JoinGroupLoading(groupId: groupId));

    final result = await _joinGroupUseCase(groupId: groupId);

    result.fold(
      (failure) => emit(_mapFailureToState(failure, groupId)),
      (_) => emit(JoinGroupSuccess(groupId: groupId)),
    );
  }

  void removeRequestLocally(String groupId) {
    emit(JoinRequestRemovedLocally(groupId: groupId));
  }

  JoinGroupFailure _mapFailureToState(Failure failure, String groupId) {
    return JoinGroupFailure(
      message: failure.message,
      errorType: failure is NetworkFailure ? 'network' : 'server',
      groupId: groupId,
    );
  }
}
