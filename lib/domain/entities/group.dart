import 'package:equatable/equatable.dart';

class Group extends Equatable {
  final String groupId;
  final String groupName;
  final String? groupCoverImage;
  final String? groupDescription;
  final int? membersCount;
  final int? adminsCount;
  final int? moderatorsCount;
  final String? role;
  final String? privacy;
  final String? creatorId;
  final String? membershipStatus;

  const Group({
    required this.groupId,
    required this.groupName,
    this.groupCoverImage,
    this.groupDescription,
    this.membersCount,
    this.adminsCount,
    this.moderatorsCount,
    this.role,
    this.privacy,
    this.creatorId,
    this.membershipStatus,
  });

  Group copyWith({
    String? membershipStatus,
  }) {
    return Group(
      groupId: groupId,
      groupName: groupName,
      groupCoverImage: groupCoverImage,
      groupDescription: groupDescription,
      membersCount: membersCount,
      adminsCount: adminsCount,
      moderatorsCount: moderatorsCount,
      role: role,
      privacy: privacy,
      creatorId: creatorId,
      membershipStatus: membershipStatus ?? membershipStatus,
    );
  }
  @override
  List<Object?> get props => [
    groupId,
    groupName,
    groupCoverImage,
    groupDescription,
    membersCount,
    adminsCount,
    moderatorsCount,
    role,
    privacy,
    creatorId,
    membershipStatus,
  ];
}
