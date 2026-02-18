import 'package:auth/domain/entities/follow_request.dart';
import 'package:auth/domain/entities/user_profile_preview.dart';

class FollowRequestModel extends FollowRequest {
  const FollowRequestModel({
    required super.id,
    required super.userId,
    required super.followerId,
    required super.follower,
    required super.status,
  });

  factory FollowRequestModel.fromJson(Map<String, dynamic> json) {
    final followerJson = json['followerId'];

    return FollowRequestModel(
      id: json['_id'],
      userId: json['userId'] is Map ? json['userId']['_id'] : json['userId'],
      followerId: followerJson['_id'],
      follower: UserProfilePreview(
        id: followerJson['_id'],
        name: followerJson['name'],
        avatarUrl: followerJson['avatar'],
      ),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'followerId': followerId,
      'status': status,
    };
  }
}
