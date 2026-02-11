import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/usecases/group/decline_join_request_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/decline_request/decline_request_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeclineRequestCubit extends Cubit<DeclineRequestState> {
  final DeclineJoinRequestUseCase _declineJoinRequestUseCase;

  DeclineRequestCubit({
    required DeclineJoinRequestUseCase declineJoinRequestUseCase,
  }) : _declineJoinRequestUseCase = declineJoinRequestUseCase,
       super(const DeclineRequestInitial());

  Future<void> declineRequest({
    required String groupId,
    required String requestId,
  }) async {
    emit(const DeclineRequestLoading());

    final result = await _declineJoinRequestUseCase(
      groupId: groupId,
      requestedId: requestId,
    );
    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (_) => emit( DeclineRequestSuccess(requestId)),
    );
  }

  DeclineRequestFailure _mapFailureToState(Failure failure) {
    switch (failure.runtimeType) {
      case const (ValidationFailure):
        return DeclineRequestFailure(
          message: failure.message,
          errorType: 'validation',
        );
      case const (NetworkFailure):
        return DeclineRequestFailure(
          message: failure.message,
          errorType: 'network',
        );
      default:
        return DeclineRequestFailure(
          message: failure.message,
          errorType: 'server',
        );
    }
  }

  void resetState() => emit(const DeclineRequestInitial());

  bool get isLoading => state is DeclineRequestLoading;
  bool get isSuccess => state is DeclineRequestSuccess;
  bool get isFailure => state is DeclineRequestFailure;
}
