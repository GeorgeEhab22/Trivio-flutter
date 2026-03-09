import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/usecases/group/cancel_request_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/cancel_request/cancel_request_group_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CancelRequestGroupCubit extends Cubit<CancelRequestGroupState> {
  final CancelRequestUseCase _cancelRequestUseCase;

  CancelRequestGroupCubit({
    required CancelRequestUseCase cancelRequestUseCase,
  })  : _cancelRequestUseCase = cancelRequestUseCase,
        super(const CancelRequestGroupInitial());

  Future<void> cancelRequestGroup({required String groupId}) async {
    emit(const CancelRequestGroupLoading());

    final result = await _cancelRequestUseCase(groupId: groupId);

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (_) => emit(const CancelRequestGroupSuccess()),
    );
  }

  CancelRequestGroupFailure _mapFailureToState(Failure failure) {

    return CancelRequestGroupFailure(
      message: failure.message,
      errorType: failure is NetworkFailure 
          ? 'network' 
          : (failure is ValidationFailure ? 'validation' : 'server'),
    );
  }

  void resetState() => emit(const CancelRequestGroupInitial());

  bool get isLoading => state is CancelRequestGroupLoading;
  bool get isSuccess => state is CancelRequestGroupSuccess;
  bool get isFailure => state is CancelRequestGroupFailure;
}