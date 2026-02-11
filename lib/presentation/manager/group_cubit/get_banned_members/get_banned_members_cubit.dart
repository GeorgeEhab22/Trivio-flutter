import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/usecases/group/members/get_group_banned_members_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:auth/presentation/manager/group_cubit/get_banned_members/get_banned_members_state.dart';

class GetBannedMembersCubit extends Cubit<GetBannedMembersState> {
  final GetGroupBannedMembersUseCase _getGroupBannedMembersUseCase;

  GetBannedMembersCubit({
    required GetGroupBannedMembersUseCase getGroupBannedMembersUseCase,
  }) : _getGroupBannedMembersUseCase = getGroupBannedMembersUseCase,
       super(GetBannedMembersInitial());

  Future<void> getBannedMembers({required String groupId}) async {
    emit(GetBannedMembersLoading());
    final result = await _getGroupBannedMembersUseCase(groupId: groupId);

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (bannedMembers) =>
          emit(GetBannedMembersSuccess(bannedMembers: bannedMembers)),
    );
  }

  GetBannedMembersFailure _mapFailureToState(Failure failure) {
    return GetBannedMembersFailure(
      message: failure.message,
      errorType: failure is NetworkFailure ? 'network' : 'server',
    );
  }
}
