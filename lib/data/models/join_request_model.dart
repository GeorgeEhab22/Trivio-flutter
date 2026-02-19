import 'package:auth/domain/entities/join_request.dart';

class JoinRequestModel extends JoinRequest {
  const JoinRequestModel({
    required super.requestId,
    required super.groupId,
    required super.userId,
    required super.userName,
    required super.userEmail,
    required super.status,
  });

  factory JoinRequestModel.fromJson(Map<String, dynamic> json) {
    final userData = json['userId'] ?? {};

    return JoinRequestModel(
      requestId: json['_id'] ?? '',
      groupId: json['groupId'] ?? '',
      userId: userData['_id'] ?? '',
      userName: userData['name'] ?? "",
      userEmail: userData['email'] ?? "",
      status: json['status'] ?? 'pending',
    );
  }
}
