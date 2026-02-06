import 'package:equatable/equatable.dart';

class Group extends Equatable {
  final String? groupId;
  final String? groupName;
  final String? groupCoverImage;
  final String? groupDescription;
  final String? membersCount;
  final String? adminsCount;
  final String? moderatorsCount;
  final String? currentRule;
  final String? privacy;

  const Group({
    this.groupId,
    this.groupName,
    this.groupCoverImage,
    this.groupDescription,
    this.membersCount,
    this.adminsCount,
    this.moderatorsCount,
    this.currentRule,
    this.privacy,
  });

  @override
  List<Object?> get props => [
    groupId,
    groupName,
    groupCoverImage,
    groupDescription,
    membersCount,
    adminsCount,
    moderatorsCount,
    currentRule,
    privacy
  ];
}
