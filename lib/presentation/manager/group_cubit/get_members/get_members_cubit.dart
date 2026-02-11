import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/usecases/group/members/get_group_members_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/get_members/get_members_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetMembersCubit extends Cubit<GetMembersState> {
  final GetGroupMembersUseCase _getgroupMembersUseCase;

  GetMembersCubit({required GetGroupMembersUseCase getgroupMembersUseCase})
    : _getgroupMembersUseCase = getgroupMembersUseCase,
      super(const GetMembersInitial());

  Future<void> getMembers({required String groupId}) async {
    emit(const GetMembersLoading());

    final result = await _getgroupMembersUseCase(groupId: groupId);

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (members) => emit(GetMembersSuccess(members: members)),
    );
  }

  GetMembersFailure _mapFailureToState(Failure failure) {
    switch (failure.runtimeType) {
      case const (ValidationFailure):
        return GetMembersFailure(
          message: failure.message,
          errorType: 'validation',
        );
      case const (NetworkFailure):
        return GetMembersFailure(
          message: failure.message,
          errorType: 'network',
        );
      default:
        return GetMembersFailure(message: failure.message, errorType: 'server');
    }
  }
}
