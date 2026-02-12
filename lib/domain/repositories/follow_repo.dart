import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/follow.dart';
import 'package:auth/domain/entities/follow_request.dart';
import 'package:dartz/dartz.dart';

abstract class FollowRepo {
  Future<Either<Failure, Follow>> followUser({required String userId});
  Future<Either<Failure, void>> unfollowUser({required String userId});
  Future<Either<Failure, List<FollowRequest>>> getMyFollowRequests();
  Future<Either<Failure, Follow>> acceptFollowRequest({required String requestId});
  Future<Either<Failure, void>> declineFollowRequest({required String requestId});
  Future<Either<Failure, List<Follow>>> getUserFollowers({required String userId});
  Future<Either<Failure, List<Follow>>> getUserFollowing({required String userId});
  Future<Either<Failure, List<Follow>>> getMyFollowers({int page = 1, int limit = 10});
  Future<Either<Failure, List<Follow>>> getMyFollowing({int page = 1, int limit = 10});
}
