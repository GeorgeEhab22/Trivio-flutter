import 'package:auth/domain/usecases/group/members/unban_member_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/unban_member/unban_member_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnbanMemberCubit extends Cubit<UnbanMemberState> {
  final UnbanMemberUseCase _unbanMemberUseCase;

  UnbanMemberCubit({required UnbanMemberUseCase unbanMemberUseCase})
    : _unbanMemberUseCase = unbanMemberUseCase,
      super(const UnbanMemberInitial());
      
  Future<void> unbanMember({
    required String groupId,
    required String targetUserId,
  }) async {
    emit(const UnbanMemberLoading());
    final result = await _unbanMemberUseCase(
      groupId: groupId,
      userId: targetUserId,
    );

    result.fold(
      (failure) => emit(UnbanMemberFailure(message: failure.message)),
      (message) => emit(UnbanMemberSuccess(message)),
    );
  }
}
