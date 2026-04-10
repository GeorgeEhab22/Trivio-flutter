import 'package:auth/domain/usecases/group/members/get_user_group_role_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_group_role_state.dart';

class UserGroupRoleCubit extends Cubit<UserGroupRoleState> {
  final GetUserGroupRoleUseCase _getUserGroupRoleUseCase;

  UserGroupRoleCubit(this._getUserGroupRoleUseCase)
    : super(UserGroupRoleInitial());

  Future<void> getUserRole(String groupId) async {
    emit(UserGroupRoleLoading());

    final result = await _getUserGroupRoleUseCase(groupId);

    result.fold(
      (failure) => emit(UserGroupRoleFailure(failure.message)),
      (role) => emit(UserGroupRoleSuccess(role)),
    );
  }
}
