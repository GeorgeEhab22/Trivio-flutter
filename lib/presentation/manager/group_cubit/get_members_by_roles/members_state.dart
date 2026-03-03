import 'package:auth/domain/entities/group_member.dart';
import 'package:equatable/equatable.dart';

class GroupMembersState extends Equatable {
  final List<GroupMember> members;
  final List<GroupMember> moderators;
  final List<GroupMember> admins;

  final bool isLoading;
  final String? errorMessage;

  // Pagination fields for Members
  final int membersPage;
  final bool hasReachedMaxMembers;
  final bool isLoadingMoreMembers;

  // Pagination fields for Moderators
  final int moderatorsPage;
  final bool hasReachedMaxModerators;
  final bool isLoadingMoreModerators;

  // Pagination fields for Admins
  final int adminsPage;
  final bool hasReachedMaxAdmins;
  final bool isLoadingMoreAdmins;

  const GroupMembersState({
    this.members = const [],
    this.moderators = const [],
    this.admins = const [],
    this.isLoading = false,
    this.errorMessage,
    this.membersPage = 1,
    this.hasReachedMaxMembers = false,
    this.isLoadingMoreMembers = false,
    this.moderatorsPage = 1,
    this.hasReachedMaxModerators = false,
    this.isLoadingMoreModerators = false,
    this.adminsPage = 1,
    this.hasReachedMaxAdmins = false,
    this.isLoadingMoreAdmins = false,
  });

  GroupMembersState copyWith({
    List<GroupMember>? members,
    List<GroupMember>? moderators,
    List<GroupMember>? admins,
    bool? isLoading,
    String? errorMessage,
    int? membersPage,
    bool? hasReachedMaxMembers,
    bool? isLoadingMoreMembers,
    int? moderatorsPage,
    bool? hasReachedMaxModerators,
    bool? isLoadingMoreModerators,
    int? adminsPage,
    bool? hasReachedMaxAdmins,
    bool? isLoadingMoreAdmins,
  }) {
    return GroupMembersState(
      members: members ?? this.members,
      moderators: moderators ?? this.moderators,
      admins: admins ?? this.admins,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      membersPage: membersPage ?? this.membersPage,
      hasReachedMaxMembers: hasReachedMaxMembers ?? this.hasReachedMaxMembers,
      isLoadingMoreMembers: isLoadingMoreMembers ?? this.isLoadingMoreMembers,
      moderatorsPage: moderatorsPage ?? this.moderatorsPage,
      hasReachedMaxModerators:
          hasReachedMaxModerators ?? this.hasReachedMaxModerators,
      isLoadingMoreModerators:
          isLoadingMoreModerators ?? this.isLoadingMoreModerators,
      adminsPage: adminsPage ?? this.adminsPage,
      hasReachedMaxAdmins: hasReachedMaxAdmins ?? this.hasReachedMaxAdmins,
      isLoadingMoreAdmins: isLoadingMoreAdmins ?? this.isLoadingMoreAdmins,
    );
  }

  @override
  List<Object?> get props => [
    members,
    moderators,
    admins,
    isLoading,
    errorMessage,
    membersPage,
    hasReachedMaxMembers,
    isLoadingMoreMembers,
    moderatorsPage,
    hasReachedMaxModerators,
    isLoadingMoreModerators,
    adminsPage,
    hasReachedMaxAdmins,
    isLoadingMoreAdmins,
  ];
}
