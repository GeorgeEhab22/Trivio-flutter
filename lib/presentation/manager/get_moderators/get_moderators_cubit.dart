import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/usecases/group/members/get_group_moderators_use_case.dart';
import 'package:auth/presentation/manager/get_moderators/get_moderators_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetModeratorsCubit extends Cubit<GetModeratorsState> {
  final GetGroupModeratorsUseCase _getgroupModeratorsUseCase;

  GetModeratorsCubit({required GetGroupModeratorsUseCase getgroupModeratorsUseCase})
      : _getgroupModeratorsUseCase = getgroupModeratorsUseCase,
        super(const GetModeratorsInitial());


  Future<void> getModerators({required String groupId}) async {
    emit(const GetModeratorsLoading());

    final result = await _getgroupModeratorsUseCase(groupId: groupId);

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (members) => emit(GetModeratorsSuccess(members: members)),
    );
  }

  GetModeratorsFailure _mapFailureToState(Failure failure) {
    switch (failure.runtimeType) {
      case const (ValidationFailure):
        return GetModeratorsFailure(message: failure.message, errorType: 'validation');
      case const (NetworkFailure):
        return GetModeratorsFailure(message: failure.message, errorType: 'network');
      default:
        return GetModeratorsFailure(message: failure.message, errorType: 'server');
    }
  }
}