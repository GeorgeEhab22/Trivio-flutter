import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/usecases/group/groups/join_group_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/join_group/join_group_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JoinGroupCubit extends Cubit<JoinGroupState> {
  final JoinGroupUseCase _joinGroupUseCase;

  JoinGroupCubit({
    required JoinGroupUseCase joinGroupUseCase,
  })  : _joinGroupUseCase = joinGroupUseCase,
        super(const JoinGroupInitial());

  Future<void> joinGroup({required String groupId}) async {
    emit(const JoinGroupLoading());

    final result = await _joinGroupUseCase(groupId: groupId);

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (_) => emit(const JoinGroupSuccess()),
    );
  }

  JoinGroupFailure _mapFailureToState(Failure failure) {
    switch (failure.runtimeType) {
      case const (ValidationFailure):
        return JoinGroupFailure(message: failure.message, errorType: 'validation');
      case const (NetworkFailure):
        return JoinGroupFailure(message: failure.message, errorType: 'network');
      default:
        return JoinGroupFailure(message: failure.message, errorType: 'server');
    }
  }

  void resetState() => emit(const JoinGroupInitial());

  bool get isLoading => state is JoinGroupLoading;
  bool get isSuccess => state is JoinGroupSuccess;
  bool get isFailure => state is JoinGroupFailure;
}