import 'package:auth/domain/entities/group_post.dart';
import 'package:auth/data/models/post_model.dart';

class GroupPostModel extends GroupPost {
  const GroupPostModel({super.post, super.groupName, super.groupCoverImage});

  factory GroupPostModel.fromJson(Map<String, dynamic> json) {
    final groupData = json['groupID'];

    return GroupPostModel(
      post: PostModel.fromJson(json),

      groupName: groupData is Map ? groupData['name'] as String? : null,
      groupCoverImage: groupData is Map ? groupData['logo'] as String? : null,
    );
  }
}
