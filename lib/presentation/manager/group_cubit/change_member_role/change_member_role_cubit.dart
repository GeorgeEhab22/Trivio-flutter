import 'package:auth/domain/usecases/group/members/change_member_rule_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/change_member_role/change_member_role_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeMemberRoleCubit extends Cubit<ChangeMemberRoleState> {
  final ChangeMemberRoleUseCase _changeMemberRoleUseCase;

  ChangeMemberRoleCubit({
    required ChangeMemberRoleUseCase changeMemberRoleUseCase,
  }) : _changeMemberRoleUseCase = changeMemberRoleUseCase,
       super(const ChangeMemberRoleInitial());

  Future<void> changeMemberRole({
    required String groupId,
    required String userId,
    required String newRole,
  }) async {
    emit(const ChangeMemberRoleLoading());

    final result = await _changeMemberRoleUseCase(
      groupId: groupId,
      userId: userId,
      newRole: newRole,
    );

    result.fold(
      (failure) => emit(ChangeMemberRoleFailure(failure.message)),
      (successMsg) => emit(ChangeMemberRoleSuccess(successMsg)),
    );
  }
}