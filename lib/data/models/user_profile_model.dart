import 'package:flutter/foundation.dart';
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
    super.privacy = false,
    super.postsCount = 0,

     super.favTeams,
    super.favPlayers,
    super.relationshipStatus='none',
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
  
    Map<String, dynamic> userData = json;
    String relStatus = 'none';
    if (json['relationshipStatus'] != null) {
      relStatus = json['relationshipStatus'].toString();
    }
    if (json['data'] != null && json['data']['user'] != null) {
      final nestedUser = json['data']['user'];
      if (nestedUser['relationshipStatus'] != null) {
        relStatus = nestedUser['relationshipStatus'].toString();
      }
      if (nestedUser['user'] != null) {
        userData = nestedUser['user'];
      } else {
        userData = nestedUser;
      }
    } else if (json['user'] != null) {
      userData = json['user'];
    }
    String avatarUrl = userData['avatar']?.toString() ?? '';
    if (avatarUrl.contains('localhost')) {
      if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS)) {
        avatarUrl = avatarUrl.replaceAll('localhost', '192.168.1.28');
      }
    }

    return UserProfileModel(
      id: userData['_id']?.toString() ?? userData['id']?.toString() ?? '',
      name: userData['username']?.toString() ?? '',
      email: userData['email']?.toString() ?? '',
      avatar: avatarUrl,
      followersCount: int.tryParse(userData['followers']?.toString() ?? '0') ?? 0,
      followingCount: int.tryParse(userData['following']?.toString() ?? '0') ?? 0,
      privacy: userData['privacy'] == 'private',
      postsCount: int.tryParse(userData['posts']?.toString() ?? '0') ?? 0,
      bio: userData['bio']?.toString(),
      favTeams: List<String>.from(userData['favTeams'] ?? []),
      favPlayers: List<String>.from(userData['favPlayers'] ?? []),
      relationshipStatus: relStatus,
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
      privacy: privacy,
      postsCount: postsCount,
      bio: bio,
      favTeams: favTeams,
      favPlayers: favPlayers,
      relationshipStatus: relationshipStatus,
    );
  }
}