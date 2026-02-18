import 'package:auth/domain/entities/user_profile_preview.dart';

class FollowRequest {
  final String id;
  final String userId; // the target user
  final String followerId; // the requesting user
  final UserProfilePreview follower; // lightweight preview
  final String status;

  const FollowRequest({
    required this.id,
    required this.userId,
    required this.followerId,
    required this.follower,
    required this.status,
  });
}
