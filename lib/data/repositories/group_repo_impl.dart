import 'package:auth/core/errors/failure.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/datasource/groups_remote_datasource.dart';
import 'package:auth/domain/entities/group.dart';
import 'package:auth/domain/entities/group_member.dart';
import 'package:auth/domain/entities/join_request.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/repositories/group_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class GroupRepoImpl implements GroupRepo {
  final GroupRemoteDataSource remoteDataSource;

  GroupRepoImpl({required this.remoteDataSource});

  // 1-create group
  @override
  Future<Either<Failure, Group>> createGroup({
    required String name,
    String? description,
    XFile? coverImage,
  }) async {
    try {
      final model = await remoteDataSource.createGroup(
        name: name,
        description: description,
        coverImage: coverImage,
      );
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to create group'));
    }
  }

  //2 -delete group
  @override
  Future<Either<Failure, String>> deleteGroup({required String groupId}) async {
    try {
      await remoteDataSource.deleteGroup(groupId);
      return const Right('Group deleted successfully');
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to delete group'));
    }
  }

  //3 -update group
  @override
  Future<Either<Failure, Group>> updateGroup({
    required String groupId,
    String? name,
    String? description,
    XFile? coverImage,
    String? privacy,
  }) async {
    try {
      final model = await remoteDataSource.updateGroup(
        groupId: groupId,
        name: name,
        description: description,
        coverImage: coverImage,
        privacy: privacy,
      );
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to update group'));
    }
  }

  // 4 -get group
  @override
  Future<Either<Failure, Group>> getGroup({required String groupId}) async {
    try {
      final model = await remoteDataSource.getGroup(groupId);
      return Right(model);
    } on ServerException catch (e) {
      // print(e);
      return Left(ServerFailure(e.message));
    } catch (a) {
      // print(a);
      return Left(ServerFailure('Group not found'));
    }
  }

  // 5 -get groups
  @override
  Future<Either<Failure, List<Group>>> getGroups({
    int page = 1,
    String? search,
  }) async {
    try {
      final models = await remoteDataSource.getGroups(
        page: page,
        search: search,
      );
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to fetch groups'));
    }
  }

  // 6 -join group
  @override
  Future<Either<Failure, String>> joinGroup({required String groupId}) async {
    try {
      final message = await remoteDataSource.joinGroup(groupId);
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to join group'));
    }
  }

  // 7 -leave group
  @override
  Future<Either<Failure, String>> leaveGroup({required String groupId}) async {
    try {
      await remoteDataSource.leaveGroup(groupId);
      return const Right('Left group successfully');
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to leave group'));
    }
  }

  // 8 -cancel join request
  @override
  Future<Either<Failure, String>> cancelRequest({
    required String groupId,
  }) async {
    try {
      await remoteDataSource.cancelJoinRequest(groupId);
      return const Right('Request cancelled');
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to cancel request'));
    }
  }

  // 9 -get join requests
  @override
  Future<Either<Failure, List<JoinRequest>>> getJoinRequests({
    required String groupId,
    int page = 1,
  }) async {
    try {
      final models = await remoteDataSource.getJoinRequests(
        groupId: groupId,
        page: page,
      );
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to fetch join requests'));
    }
  }

  //10- accept join request
  @override
  Future<Either<Failure, String>> acceptJoinRequest({
    required String groupId,
    required String requestedId,
  }) async {
    try {
      await remoteDataSource.acceptJoinRequest(
        groupId: groupId,
        requestId: requestedId,
      );
      return const Right('Request accepted');
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to accept request'));
    }
  }

  //11- decline join request
  @override
  Future<Either<Failure, String>> declineJoinRequest({
    required String groupId,
    required String requestedId,
  }) async {
    try {
      await remoteDataSource.declineJoinRequest(
        groupId: groupId,
        requestId: requestedId,
      );
      return const Right('Request declined');
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to decline request'));
    }
  }

  //12- change member role
  @override
  Future<Either<Failure, String>> changeMemberRole({
    required String groupId,
    required String userId,
    required String newRole,
  }) async {
    try {
      await remoteDataSource.promoteMember(
        groupId: groupId,
        userId: userId,
        role: newRole,
      );
      return const Right('Role changed successfully');
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to change member role'));
    }
  }

  // 13-kick member
  @override
  Future<Either<Failure, String>> kickMember({
    required String groupId,
    required String userId,
  }) async {
    try {
      await remoteDataSource.kickMember(groupId: groupId, userId: userId);
      return const Right('Member kicked');
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to kick member'));
    }
  }

  // 14-ban member
  @override
  Future<Either<Failure, String>> banMember({
    required String groupId,
    required String userId,
  }) async {
    try {
      await remoteDataSource.banMember(groupId: groupId, userId: userId);
      return const Right('Member banned');
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to ban member'));
    }
  }

  //15- unban member
  @override
  Future<Either<Failure, String>> unbanMember({
    required String groupId,
    required String userId,
  }) async {
    try {
      await remoteDataSource.unbanMember(groupId: groupId, userId: userId);
      return const Right('Member unbanned');
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to unban member'));
    }
  }

  //16- get members
  @override
  Future<Either<Failure, List<GroupMember>>> getGroupMembers({
    required String groupId,
    int page = 1,
  }) async {
    try {
      final models = await remoteDataSource.getMembers(
        groupId: groupId,
        page: page,
      );
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to fetch members'));
    }
  }

  //17- get admins
  @override
  Future<Either<Failure, List<GroupMember>>> getGroupAdmins({
    required String groupId,
    int page = 1,
  }) async {
    try {
      final models = await remoteDataSource.getAdmins(
        groupId: groupId,
        page: page,
      );
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to fetch members'));
    }
  }

  //18- get moderators
  @override
  Future<Either<Failure, List<GroupMember>>> getGroupModerators({
    required String groupId,
    int page = 1,
  }) async {
    try {
      final models = await remoteDataSource.getModerators(
        groupId: groupId,
        page: page,
      );
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to fetch members'));
    }
  }

  //19- get banned members
  @override
  Future<Either<Failure, List<GroupMember>>> getGroupBannedMembers({
    required String groupId,
    int page = 1,
  }) async {
    try {
      final models = await remoteDataSource.getBannedMembers(
        groupId: groupId,
        page: page,
      );
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to fetch members'));
    }
  }

  // 20-get my groups
  @override
  Future<Either<Failure, List<Group>>> getMyGroups({
    int page = 1,
    String? search,
  }) async {
    try {
      final models = await remoteDataSource.getMyGroups(
        page: page,
        search: search,
      );
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to fetch my groups'));
    }
  }

  //21- get joined groups
  @override
  Future<Either<Failure, List<Group>>> getJoinedGroups({
    int page = 1,
    String? search,
  }) async {
    try {
      final models = await remoteDataSource.getJoinedGroups(
        page: page,
        search: search,
      );
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to fetch joined groups'));
    }
  }

  // 22-create group post
  @override
  Future<Either<Failure, Post>> createGroupPost({
    required String groupId,
    String? caption,
    List<XFile>? media,
    required String type,
  }) async {
    try {
      final model = await remoteDataSource.createGroupPost(
        groupId: groupId,
        caption: caption,
        media: media,
        type: type,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to create post'));
    }
  }

  // 23-delete group post
  @override
  Future<Either<Failure, String>> deleteGroupPost({
    required String groupId,
    required String postId,
  }) async {
    try {
      await remoteDataSource.deleteGroupPost(groupId: groupId, postId: postId);
      return const Right('Post deleted');
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to delete post'));
    }
  }

  //24- edit group post
  @override
  Future<Either<Failure, Post>> editGroupPost({
    required String groupId,
    required String postId,
    required String newCaption,
    List<String>? media,
  }) async {
    try {
      final model = await remoteDataSource.updateGroupPost(
        groupId: groupId,
        postId: postId,
        caption: newCaption,
      );
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to edit post'));
    }
  }

  // 25-get group post by id
  @override
  Future<Either<Failure, Post>> getGroupPostById(
    String groupId,
    String postId,
  ) async {
    try {
      final model = await remoteDataSource.getGroupPostById(
        groupId: groupId,
        postId: postId,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Post not found or access denied'));
    }
  }

  //26- get group posts
  @override
  Future<Either<Failure, List<Post>>> getGroupPosts({
    required String groupId,
    int page = 1,
  }) async {
    try {
      final models = await remoteDataSource.getGroupPosts(
        groupId: groupId,
        page: page,
      );
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to fetch posts'));
    }
  }

  //27- get group feed
  @override
  Future<Either<Failure, List<Post>>> getGroupsFeed({int page = 1}) async {
    try {
      final models = await remoteDataSource.getGroupFeed(page: page);
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to fetch feed'));
    }
  }
}
