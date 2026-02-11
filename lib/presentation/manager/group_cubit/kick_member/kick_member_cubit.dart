import 'package:auth/domain/usecases/group/members/kick_member_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/kick_member/kick_member_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KickMemberCubit extends Cubit<KickMemberState> {
  final KickMemberUseCase _kickMemberUseCase;

  KickMemberCubit({required KickMemberUseCase kickMemberUseCase})
    : _kickMemberUseCase = kickMemberUseCase,
      super(const KickMemberInitial());
  Future<void> kickMember({
    required String groupId,
    required String targetUserId,
  }) async {
    emit(const KickMemberLoading());
    final result = await _kickMemberUseCase(
      groupId: groupId,
      userId: targetUserId,
    );

    result.fold(
      (failure) => emit(
        KickMemberFailure(
          message: failure.message,
          errorType: failure.message.contains('limit')
              ? 'rate_limit'
              : 'server',
        ),
      ),
      (message) => emit(KickMemberSuccess(message)),
    );
  }
}
