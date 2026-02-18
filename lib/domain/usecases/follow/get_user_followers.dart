import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/follow.dart';
import 'package:auth/domain/repositories/follow_repo.dart';
import 'package:dartz/dartz.dart';

class GetUserFollowers {
  final FollowRepo repository;

  GetUserFollowers(this.repository);

  Future<Either<Failure, List<Follow>>> call({required String userId}) async {
    return await repository.getUserFollowers(userId: userId);
  }
}
