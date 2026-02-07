import 'package:auth/core/errors/failure.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/datasource/groups_remote_datasource.dart';
import 'package:auth/domain/entities/group.dart';
import 'package:auth/domain/entities/group_member.dart';
import 'package:auth/domain/entities/group_post.dart';
import 'package:auth/domain/repositories/group_repo.dart';
import 'package:dartz/dartz.dart';

class GroupRepoImpl implements GroupRepo {
  final GroupRemoteDataSource remoteDataSource;

  GroupRepoImpl({required this.remoteDataSource});

  // --- 1. Core Group Actions ---

  @override
  Future<Either<Failure, Group>> createGroup({
    required String name,
    required String description,
    required String coverImage,
    String? privacy,
  }) async {
    try {
      final model = await remoteDataSource.createGroup(
        name: name,
        description: description,
        coverImage: coverImage,
        privacy: privacy,
      );
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to create group'));
    }
  }

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

  @override
  Future<Either<Failure, Group>> getGroup({required String groupId}) async {
    try {
      final model = await remoteDataSource.getGroup(groupId);
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Group not found'));
    }
  }

  @override
  Future<Either<Failure, Group>> updateGroup({
    required String groupId,
    String? name,
    String? description,
    String? coverImage,
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

  // --- 2. Membership & Requests ---

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

  @override
  Future<Either<Failure, List<GroupMember>>> getJoinRequests({
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

  @override
  Future<Either<Failure, String>> acceptJoinRequest({
    required String groupId,
    required String userId,
  }) async {
    try {
      await remoteDataSource.acceptJoinRequest(
        groupId: groupId,
        requestId: userId,
      );
      return const Right('Request accepted');
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to accept request'));
    }
  }

  @override
  Future<Either<Failure, String>> declineJoinRequest({
    required String groupId,
    required String userId,
  }) async {
    try {
      await remoteDataSource.declineJoinRequest(
        groupId: groupId,
        requestId: userId,
      );
      return const Right('Request declined');
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to decline request'));
    }
  }

  // --- 3. Moderation & Roles ---

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

  @override
  Future<Either<Failure, List<GroupMember>>> getGroupMembers({
    required String groupId,
    required String role,
    int page = 1,
  }) async {
    try {
      final models = await remoteDataSource.getMembers(
        groupId: groupId,
        role: role,
        page: page,
      );
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to fetch members'));
    }
  }

  // --- 4. Posts Management ---

  @override
  Future<Either<Failure, GroupPost>> createGroupPost({
    required String groupId,
    required String caption,
    List<String>? media,
  }) async {
    try {
      final model = await remoteDataSource.createGroupPost(
        groupId: groupId,
        caption: caption,
      );
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to create post'));
    }
  }

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

  @override
  Future<Either<Failure, GroupPost>> editGroupPost({
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

  @override
  Future<Either<Failure, List<GroupPost>>> getGroupPosts({
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

  @override
  Future<Either<Failure, List<GroupPost>>> getGroupsFeed({int page = 1}) async {
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
