import 'package:auth/domain/usecases/group/members/ban_member_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/ban_member/ban_member_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BanMemberCubit extends Cubit<BanMemberState> {
  final BanMemberUseCase _banMemberUseCase;

  BanMemberCubit({required BanMemberUseCase banMemberUseCase})
    : _banMemberUseCase = banMemberUseCase,
      super(const BanMemberInitial());
  Future<void> banMember({
    required String groupId,
    required String targetUserId,
  }) async {
    emit(const BanMemberLoading());
    final result = await _banMemberUseCase(
      groupId: groupId,
      userId: targetUserId,
    );

    result.fold(
      (failure) => emit(BanMemberFailure(message: failure.message)),
      (message) => emit(BanMemberSuccess(message)),
    );
  }
}
