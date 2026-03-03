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
    emit(
      state.copyWith(
        isLoading: true,
        membersPage: 1,
        moderatorsPage: 1,
        adminsPage: 1,
        hasReachedMaxMembers: false,
        hasReachedMaxModerators: false,
        hasReachedMaxAdmins: false,
      ),
    );

    final results = await Future.wait([
      _getMembersUseCase(groupId: groupId, page: 1),
      _getModeratorsUseCase(groupId: groupId, page: 1),
      _getAdminsUseCase(groupId: groupId, page: 1),
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
        membersPage: 2,
        moderatorsPage: 2,
        adminsPage: 2,
        hasReachedMaxMembers: members.length < 10,
        hasReachedMaxModerators: moderators.length < 10,
        hasReachedMaxAdmins: admins.length < 10,
      ),
    );
  }

  Future<void> loadMoreMembers(String groupId) async {
    if (state.isLoadingMoreMembers || state.hasReachedMaxMembers) return;
    emit(state.copyWith(isLoadingMoreMembers: true));
    final result = await _getMembersUseCase(
      groupId: groupId,
      page: state.membersPage,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoadingMoreMembers: false,
          errorMessage: failure.message,
        ),
      ),
      (newItems) {
        if (newItems.isEmpty) {
          emit(
            state.copyWith(
              isLoadingMoreMembers: false,
              hasReachedMaxMembers: true,
            ),
          );
        } else {
          final existingIds = state.members.map((m) => m.userId).toSet();
          final uniqueItems = newItems
              .where((m) => !existingIds.contains(m.userId))
              .toList();
          emit(
            state.copyWith(
              members: [...state.members, ...uniqueItems],
              membersPage: state.membersPage + 1,
              isLoadingMoreMembers: false,
              hasReachedMaxMembers: newItems.length < 10,
            ),
          );
        }
      },
    );
  }

  Future<void> loadMoreModerators(String groupId) async {
    if (state.isLoadingMoreModerators || state.hasReachedMaxModerators) return;
    emit(state.copyWith(isLoadingMoreModerators: true));
    final result = await _getModeratorsUseCase(
      groupId: groupId,
      page: state.moderatorsPage,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoadingMoreModerators: false,
          errorMessage: failure.message,
        ),
      ),
      (newItems) {
        if (newItems.isEmpty) {
          emit(
            state.copyWith(
              isLoadingMoreModerators: false,
              hasReachedMaxModerators: true,
            ),
          );
        } else {
          final existingIds = state.moderators.map((m) => m.userId).toSet();
          final uniqueItems = newItems
              .where((m) => !existingIds.contains(m.userId))
              .toList();
          emit(
            state.copyWith(
              moderators: [...state.moderators, ...uniqueItems],
              moderatorsPage: state.moderatorsPage + 1,
              isLoadingMoreModerators: false,
              hasReachedMaxModerators: newItems.length < 10,
            ),
          );
        }
      },
    );
  }

  Future<void> loadMoreAdmins(String groupId) async {
    if (state.isLoadingMoreAdmins || state.hasReachedMaxAdmins) return;
    emit(state.copyWith(isLoadingMoreAdmins: true));
    final result = await _getAdminsUseCase(
      groupId: groupId,
      page: state.adminsPage,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoadingMoreAdmins: false,
          errorMessage: failure.message,
        ),
      ),
      (newItems) {
        if (newItems.isEmpty) {
          emit(
            state.copyWith(
              isLoadingMoreAdmins: false,
              hasReachedMaxAdmins: true,
            ),
          );
        } else {
          final existingIds = state.admins.map((m) => m.userId).toSet();
          final uniqueItems = newItems
              .where((m) => !existingIds.contains(m.userId))
              .toList();
          emit(
            state.copyWith(
              admins: [...state.admins, ...uniqueItems],
              adminsPage: state.adminsPage + 1,
              isLoadingMoreAdmins: false,
              hasReachedMaxAdmins: newItems.length < 10,
            ),
          );
        }
      },
    );
  }

  void removeMemberLocally(String userId) {
    emit(
      state.copyWith(
        members: state.members.where((m) => m.userId != userId).toList(),
        moderators: state.moderators.where((m) => m.userId != userId).toList(),
        admins: state.admins.where((m) => m.userId != userId).toList(),
      ),
    );
  }

  void updateMemberRoleLocally(String userId, String newRole) {
    final all = [...state.members, ...state.moderators, ...state.admins];
    final userIndex = all.indexWhere((m) => m.userId == userId);
    if (userIndex == -1) return;

    final updatedUser = all[userIndex].copyWith(role: newRole);

    final newMembers = state.members.where((m) => m.userId != userId).toList();
    final newModerators = state.moderators
        .where((m) => m.userId != userId)
        .toList();
    final newAdmins = state.admins.where((m) => m.userId != userId).toList();

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
