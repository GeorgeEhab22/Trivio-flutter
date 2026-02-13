

import 'package:auth/core/errors/failure.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/datasource/follow_remote_datasource.dart';
import 'package:auth/domain/entities/follow.dart';
import 'package:auth/domain/entities/follow_request.dart';
import 'package:auth/domain/repositories/follow_repo.dart';
import 'package:dartz/dartz.dart';

class FollowRepoImpl implements FollowRepo {
  final FollowRemoteDataSource remote;

  FollowRepoImpl({required this.remote});

  @override
  Future<Either<Failure, Follow>> followUser({required String userId}) async {
    try {
      final follow = await remote.followUser(userId: userId);
      return Right(follow);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> unfollowUser({required String userId}) async {
    try {
      await remote.unfollowUser(userId: userId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<FollowRequest>>> getMyFollowRequests() async {
    try {
      final requests = await remote.getMyFollowRequests();
      return Right(requests);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Follow>> acceptFollowRequest({required String requestId}) async {
    try {
      final follow = await remote.acceptFollowRequest(requestId: requestId);
      return Right(follow);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> declineFollowRequest({required String requestId}) async {
    try {
      await remote.declineFollowRequest(requestId: requestId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Follow>>> getUserFollowers({required String userId}) async {
    try {
      final followers = await remote.getUserFollowers(userId: userId);
      return Right(followers);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Follow>>> getUserFollowing({required String userId}) async {
    try {
      final following = await remote.getUserFollowing(userId: userId);
      return Right(following);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Follow>>> getMyFollowers({int page = 1, int limit = 10}) async {
    try {
      final followers = await remote.getMyFollowers(page: page, limit: limit);
      return Right(followers);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Follow>>> getMyFollowing({int page = 1, int limit = 10}) async {
    try {
      final following = await remote.getMyFollowing(page: page, limit: limit);
      return Right(following);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}