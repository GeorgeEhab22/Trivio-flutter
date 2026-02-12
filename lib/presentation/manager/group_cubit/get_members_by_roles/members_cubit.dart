import 'package:auth/domain/entities/group_member.dart';
import 'package:auth/domain/usecases/group/members/get_group_admins_use_case.dart';
import 'package:auth/domain/usecases/group/members/get_group_members_use_case.dart';
import 'package:auth/domain/usecases/group/members/get_group_moderators_use_case.dart';
import 'package:auth/presentation/manager/group_cubit/get_members_by_roles/members_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupMembersCubit extends Cubit<GroupMembersState> {
  final GetGroupMembersUseCase _getMembersUseCase;
  final GetGroupModeratorsUseCase _getModeratorsUseCase;
  final GetGroupAdminsUseCase _getAdminsUseCase;

  GroupMembersCubit(
    this._getMembersUseCase,
    this._getModeratorsUseCase,
    this._getAdminsUseCase,
  ) : super(const GroupMembersState());

  Future<void> getAllGroupData(String groupId) async {
    emit(state.copyWith(isLoading: true));

    final results = await Future.wait([
      _getMembersUseCase(groupId: groupId),
      _getModeratorsUseCase(groupId: groupId),
      _getAdminsUseCase(groupId: groupId),
    ]);

    List<GroupMember> members = [];
    results[0].fold((l) => null, (r) => members = r);

    List<GroupMember> moderators = [];
    results[1].fold((l) => null, (r) => moderators = r);

    List<GroupMember> admins = [];
    results[2].fold((l) => null, (r) => admins = r);

    emit(
      state.copyWith(
        members: members,
        moderators: moderators,
        admins: admins,
        isLoading: false,
      ),
    );
  }

  void removeMemberLocally(String userId) {
    emit(
      state.copyWith(
        members: List<GroupMember>.from(
          state.members.where((m) => m.userId != userId),
        ),
        moderators: List<GroupMember>.from(
          state.moderators.where((m) => m.userId != userId),
        ),
        admins: List<GroupMember>.from(
          state.admins.where((m) => m.userId != userId),
        ),
      ),
    );
  }

  void updateMemberRoleLocally(String userId, String newRole) {
    final allMembers = [...state.members, ...state.moderators, ...state.admins];

    final userIndex = allMembers.indexWhere((m) => m.userId == userId);
    if (userIndex == -1) return;

    final user = allMembers[userIndex];

    final updatedUser = user.copyWith(role: newRole);

    final newMembers = List<GroupMember>.from(
      state.members.where((m) => m.userId != userId),
    );
    final newModerators = List<GroupMember>.from(
      state.moderators.where((m) => m.userId != userId),
    );
    final newAdmins = List<GroupMember>.from(
      state.admins.where((m) => m.userId != userId),
    );

    if (newRole == 'moderator') {
      newModerators.add(updatedUser);
    } else if (newRole == 'admin') {
      newAdmins.add(updatedUser);
    } else {
      newMembers.add(updatedUser);
    }

    emit(
      state.copyWith(
        members: newMembers,
        moderators: newModerators,
        admins: newAdmins,
      ),
    );
  }
}
