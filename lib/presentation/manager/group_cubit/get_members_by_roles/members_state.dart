import 'package:auth/domain/entities/group_member.dart';
import 'package:equatable/equatable.dart';

class GroupMembersState extends Equatable {
  final List<GroupMember> members;
  final List<GroupMember> moderators;
  final List<GroupMember> admins;
  final bool isLoading;
  final String? errorMessage;

  const GroupMembersState({
    this.members = const [],
    this.moderators = const [],
    this.admins = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  GroupMembersState copyWith({
    List<GroupMember>? members,
    List<GroupMember>? moderators,
    List<GroupMember>? admins,
    bool? isLoading,
    String? errorMessage,
  }) {
    return GroupMembersState(
      members: members ?? this.members,
      moderators: moderators ?? this.moderators,
      admins: admins ?? this.admins,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [members, moderators, admins, isLoading, errorMessage];
}