import 'package:auth/domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {

  UserProfileModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatar = '',
    super.bio,
    super.followersCount = 0,
    super.followingCount = 0,
    super.postsCount = 0,

     super.favTeams,
    super.favPlayers,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      avatar: json['avatar']?.toString() ?? '',
      followersCount: int.tryParse(json['followers']?.toString() ?? '0') ?? 0,
      followingCount: int.tryParse(json['following']?.toString() ?? '0') ?? 0,
      postsCount: int.tryParse(json['posts']?.toString() ?? '0') ?? 0,

      favTeams: List<String>.from(json['favTeams'] ?? []),
      favPlayers: List<String>.from(json['favPlayers'] ?? []),
    );
  }

  UserProfile toEntity() {
    return UserProfile(
      id: id,
      name: name,
      email: email,
      avatar: avatar,
      followersCount: followersCount,
      followingCount: followingCount,
      postsCount: postsCount,

      favTeams: favTeams,
      favPlayers: favPlayers,
    );
  }
}
