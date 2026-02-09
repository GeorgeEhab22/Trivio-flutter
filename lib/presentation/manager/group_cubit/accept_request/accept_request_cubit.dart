import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/usecases/group/accept_join_request_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/accept_request/accept_request_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AcceptRequestCubit extends Cubit<AcceptRequestState> {
  final AcceptJoinRequestUseCase _acceptJoinRequestUseCase;

  AcceptRequestCubit({
    required AcceptJoinRequestUseCase acceptJoinRequestUseCase,
  }) : _acceptJoinRequestUseCase = acceptJoinRequestUseCase,
       super(const AcceptRequestInitial());

  Future<void> acceptRequest({
    required String groupId,
    required String requestId,
  }) async {
    emit(const AcceptRequestLoading());

    final result = await _acceptJoinRequestUseCase(
      groupId: groupId,
      requestedId: requestId,
    );
    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (_) => emit(const AcceptRequestSuccess()),
    );
  }

  AcceptRequestFailure _mapFailureToState(Failure failure) {
    switch (failure.runtimeType) {
      case const (ValidationFailure):
        return AcceptRequestFailure(
          message: failure.message,
          errorType: 'validation',
        );
      case const (NetworkFailure):
        return AcceptRequestFailure(
          message: failure.message,
          errorType: 'network',
        );
      default:
        return AcceptRequestFailure(
          message: failure.message,
          errorType: 'server',
        );
    }
  }

  void resetState() => emit(const AcceptRequestInitial());

  bool get isLoading => state is AcceptRequestLoading;
  bool get isSuccess => state is AcceptRequestSuccess;
  bool get isFailure => state is AcceptRequestFailure;
}
