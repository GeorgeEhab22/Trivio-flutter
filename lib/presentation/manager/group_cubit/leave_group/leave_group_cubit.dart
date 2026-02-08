import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/usecases/group/groups/leave_group_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/leave_group/leave_group_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaveGroupCubit extends Cubit<LeaveGroupState> {
  final LeaveGroupUseCase _leaveGroupUseCase;

  LeaveGroupCubit({
    required LeaveGroupUseCase leaveGroupUseCase,
  })  : _leaveGroupUseCase = leaveGroupUseCase,
        super(const LeaveGroupInitial());

  Future<void> leaveGroup({required String groupId}) async {
    emit(const LeaveGroupLoading());

    final result = await _leaveGroupUseCase(groupId: groupId);

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (_) => emit(const LeaveGroupSuccess()),
    );
  }

  LeaveGroupFailure _mapFailureToState(Failure failure) {
    switch (failure.runtimeType) {
      case const (ValidationFailure):
        return LeaveGroupFailure(message: failure.message, errorType: 'validation');
      case const (NetworkFailure):
        return LeaveGroupFailure(message: failure.message, errorType: 'network');
      case const (AuthFailure):
        return LeaveGroupFailure(message: failure.message, errorType: 'auth');
      default:
        return LeaveGroupFailure(message: failure.message, errorType: 'server');
    }
  }

  void resetState() => emit(const LeaveGroupInitial());

  bool get isLoading => state is LeaveGroupLoading;
  bool get isSuccess => state is LeaveGroupSuccess;
  bool get isFailure => state is LeaveGroupFailure;
}