import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/follow.dart';
import 'package:auth/domain/repositories/follow_repo.dart';
import 'package:dartz/dartz.dart';

class GetMyFollowing {
  final FollowRepo repository;

  GetMyFollowing(this.repository);

  Future<Either<Failure, List<Follow>>> call({int page = 1, int limit = 10}) async {
    return await repository.getMyFollowing(page: page, limit: limit);
  }
}
