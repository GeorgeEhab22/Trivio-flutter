import 'package:equatable/equatable.dart';

class GroupMember extends Equatable {
  final String? userId;
  final String? userName;
  final String? profileImageUrl;
  final String? role; // admin , moderator , member
  final String? status; // active , banned

  const GroupMember({
    this.userId,
    this.userName,
    this.profileImageUrl,
    this.role,
    this.status,
  });

  @override
  List<Object?> get props => [userId, userName, profileImageUrl, role, status];
}
