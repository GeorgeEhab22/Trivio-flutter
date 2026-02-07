import 'package:auth/domain/entities/group_member.dart';

class GroupMemberModel extends GroupMember {
  const GroupMemberModel({
    super.userId,
    super.userName,
    super.profileImageUrl,
    super.role,
    super.status,
  });

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) {
    final userData = json['userId'];

    return GroupMemberModel(
      userId: userData is Map
          ? userData['_id'] as String?
          : userData as String?,
      userName: userData is Map ? userData['name'] as String? : null,
      profileImageUrl: userData is Map
          ? userData['profileImage'] as String?
          : null,
      role: json['role'] as String?,
      status: json['status'] as String?,
    );
  }
}
