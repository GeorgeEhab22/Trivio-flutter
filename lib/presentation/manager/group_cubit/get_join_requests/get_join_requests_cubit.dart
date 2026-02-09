import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/usecases/group/get_join_requests_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/get_join_requests/get_join_requests_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetJoinRequestsCubit extends Cubit<GetJoinRequestsState> {
  final GetJoinRequestsUseCase _getJoinRequestsUseCase;

  GetJoinRequestsCubit({required GetJoinRequestsUseCase getJoinRequestsUseCase})
    : _getJoinRequestsUseCase = getJoinRequestsUseCase,
      super(const GetJoinRequestsInitial());

  Future<void> getJoinRequestsGroup({required String groupId}) async {
    emit(const GetJoinRequestsLoading());

    final result = await _getJoinRequestsUseCase(groupId: groupId);

    result.fold((failure) => emit(_mapFailureToState(failure)), (requests) {
      if (requests.isEmpty) {
        emit(const GetJoinRequestsEmpty());
      }
      emit(GetJoinRequestsSuccess(requests: requests));
    });
  }

  GetJoinRequestsFailure _mapFailureToState(Failure failure) {
    switch (failure.runtimeType) {
      case const (ValidationFailure):
        return GetJoinRequestsFailure(
          message: failure.message,
          errorType: 'validation',
        );
      case const (NetworkFailure):
        return GetJoinRequestsFailure(
          message: failure.message,
          errorType: 'network',
        );
      default:
        return GetJoinRequestsFailure(
          message: failure.message,
          errorType: 'server',
        );
    }
  }

  void resetState() => emit(const GetJoinRequestsInitial());

  bool get isLoading => state is GetJoinRequestsLoading;
  bool get isSuccess => state is GetJoinRequestsSuccess;
  bool get isFailure => state is GetJoinRequestsFailure;
}
