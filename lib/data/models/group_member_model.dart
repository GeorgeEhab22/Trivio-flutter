import 'package:auth/domain/entities/group_member.dart';

class GroupMemberModel extends GroupMember {
  const GroupMemberModel({
    required super.userId,
    required super.userName,
    super.profileImageUrl,
    required super.role,
    required super.status,
  });

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) {
    final userData = json['userId'];

    //TODO : remove when backend is fixed to add mobile ip
    // and change to your ip

    String? image = userData is Map
        ? (userData['profileImage'] ?? userData['image']) as String?
        : null;
    if (image != null && image.contains('localhost')) {
      image = image.replaceAll('localhost', '192.168.1.5');
    }

    return GroupMemberModel(
      userId: userData is Map ? userData['_id'] as String : userData as String,
      userName: userData is Map
          ? (userData['name'] ?? userData['username']) as String
          : "Unknown User",
      profileImageUrl: image,
      role: json['role'] as String,
      status: json['status'] as String,
    );
  }
}
