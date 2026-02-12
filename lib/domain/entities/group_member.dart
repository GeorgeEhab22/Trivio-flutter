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

  GroupMember copyWith({
    String? userId,
    String? userName,
    String? profileImageUrl,
    String? role,
    String? status,
  }) {
    return GroupMember(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [userId, userName, profileImageUrl, role, status];
}
