import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/group.dart';
import 'package:auth/domain/entities/group_member.dart';
import 'package:auth/domain/entities/group_post.dart';
import 'package:auth/domain/entities/join_request.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

abstract class GroupRepo {
  // 1 create group
  Future<Either<Failure, Group>> createGroup({
    required String name,
    String? description,
    XFile? coverImage,
  });

  // 2 delete group
  Future<Either<Failure, String>> deleteGroup({required String groupId});

  // 3 get group
  Future<Either<Failure, Group>> getGroup({required String groupId});

  // 4 update group
  Future<Either<Failure, Group>> updateGroup({
    required String groupId,
    String? name,
    String? description,
    XFile? coverImage,
    String? privacy,
  });

  // 5 get groups
  Future<Either<Failure, List<Group>>> getGroups({
    int page = 1,
    String? search,
  });

  // 6 join group
  Future<Either<Failure, String>> joinGroup({required String groupId});

  // 7 leave group
  Future<Either<Failure, String>> leaveGroup({required String groupId});
  //8 cancel request
  Future<Either<Failure, String>> cancelRequest({required String groupId});

  // 9 get join requests
  Future<Either<Failure, List<JoinRequest>>> getJoinRequests({
    required String groupId,
    int page = 1,
  });

  // 10 accept join request
  Future<Either<Failure, String>> acceptJoinRequest({
    required String groupId,
    required String requestedId,
  });

  // 11 decline join request
  Future<Either<Failure, String>> declineJoinRequest({
    required String groupId,
    required String requestedId,
  });

  // 12 change member role
  Future<Either<Failure, String>> changeMemberRole({
    required String groupId,
    required String userId,
    required String newRole, // admin , moderator , member
  });

  // 13 kick member
  Future<Either<Failure, String>> kickMember({
    required String groupId,
    required String userId,
  });

  // 14 ban member
  Future<Either<Failure, String>> banMember({
    required String groupId,
    required String userId,
  });

  // 15 unban member
  Future<Either<Failure, String>> unbanMember({
    required String groupId,
    required String userId,
  });

  // 16 members , 17 baned members , 18 admins , 19 moderators
  Future<Either<Failure, List<GroupMember>>> getGroupMembers({
    required String groupId,
    int page = 1,
  });
  Future<Either<Failure, List<GroupMember>>> getGroupAdmins({
    required String groupId,
    int page = 1,
  });
  Future<Either<Failure, List<GroupMember>>> getGroupModerators({
    required String groupId,
    int page = 1,
  });
  Future<Either<Failure, List<GroupMember>>> getGroupBannedMembers({
    required String groupId,
    int page = 1,
  });

  // 20 group posts
  Future<Either<Failure, GroupPost>> createGroupPost({
    required String groupId,
    String? caption,
    List<String>? media,
  });

  // 21 delete group post
  Future<Either<Failure, String>> deleteGroupPost({
    required String groupId,
    required String postId,
    required String userId,
  });

  // 22 edit group post
  Future<Either<Failure, GroupPost>> editGroupPost({
    required String groupId,
    required String postId,
    required String userId,
    required String newCaption,
    List<String>? media,
  });

  // 23 get group posts
  Future<Either<Failure, List<GroupPost>>> getGroupPosts({
    required String groupId,
    int page = 1,
  });

  // 24 get groups feed
  Future<Either<Failure, List<GroupPost>>> getGroupsFeed({int page = 1});
}
