import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/usecases/group/members/get_group_admins_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/get_admins/get_admins_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetAdminsCubit extends Cubit<GetAdminsState> {
  final GetGroupAdminsUseCase _getgroupAdminsUseCase;

  GetAdminsCubit({required GetGroupAdminsUseCase getgroupAdminsUseCase})
    : _getgroupAdminsUseCase = getgroupAdminsUseCase,
      super(const GetAdminsInitial());

  Future<void> getAdmins({required String groupId}) async {
    emit(const GetAdminsLoading());

    final result = await _getgroupAdminsUseCase(groupId: groupId);

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (admins) => emit(GetAdminsSuccess(admins: admins)),
    );
  }

  GetAdminsFailure _mapFailureToState(Failure failure) {
    switch (failure.runtimeType) {
      case const (ValidationFailure):
        return GetAdminsFailure(
          message: failure.message,
          errorType: 'validation',
        );
      case const (NetworkFailure):
        return GetAdminsFailure(message: failure.message, errorType: 'network');
      default:
        return GetAdminsFailure(message: failure.message, errorType: 'server');
    }
  }
}
