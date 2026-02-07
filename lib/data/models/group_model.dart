import 'package:auth/domain/entities/group.dart';

class GroupModel extends Group {
  const GroupModel({
    super.groupId,
    super.groupName,
    super.groupCoverImage,
    super.groupDescription,
    super.membersCount,
    super.adminsCount,
    super.moderatorsCount,
    super.role,
    super.privacy,
    super.creatorId,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = json['group'] ?? json;

    return GroupModel(
      groupId: data['_id'] as String?,
      groupName: data['name'] as String?,
      groupDescription: data['description'] as String?,
      groupCoverImage: data['logo'] as String?,
      membersCount: data['members'] as int? ?? 0,
      adminsCount: data['admins'] as int? ?? 0,
      moderatorsCount: data['moderators'] as int? ?? 0,
      role: data['role'] as String?,
      privacy: data['privacy'] as String?,
      creatorId: data['creatorId'] is Map
          ? data['creatorId']['_id']
          : data['creatorId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': groupName,
      'description': groupDescription,
      'privacy': privacy,
    };
  }
}
