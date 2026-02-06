import 'package:auth/domain/entities/post.dart';
import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String userId;
  final String username;
  final String? about;
  final String? profileImageUrl;
  final int? followersCount;
  final int? followingCount;
  final int? postsCount;
  final List<Post>? posts;

  const UserProfile({
    required this.userId,
    required this.username,
    this.about,
    this.profileImageUrl,
    this.followersCount,
    this.followingCount,
    this.postsCount,
    this.posts,
  });

  @override
  List<Object?> get props => [
        userId,
        username,
        about,
        profileImageUrl,
        followersCount,
        followingCount,
        postsCount,
        posts,
      ];
}
