import 'package:auth/domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  final String id;
  final String name;
  final String email;
  final String role;
  final String privacy; // now just a string
  final int followersCount;
  final int followingCount;
  final DateTime? createdAt;

  UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.privacy = "public",
    this.followersCount = 0,
    this.followingCount = 0,
    this.createdAt,
  }) : super(id: id, name: name, email: email, role: role);

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'] ?? 'user',
      privacy: json['privacy'], // just store the string
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  UserProfile toEntity() {
    return UserProfile(
      id: id,
      name: name,
      email: email,
      role: role,
      privacy: privacy,
      followersCount: followersCount,
      followingCount: followingCount,
      createdAt: createdAt,
    );
  }
}
