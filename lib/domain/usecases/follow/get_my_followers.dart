import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/follow.dart';
import 'package:auth/domain/repositories/follow_repo.dart';
import 'package:dartz/dartz.dart';

class GetMyFollowers {
  final FollowRepo repository;

  GetMyFollowers(this.repository);

  Future<Either<Failure, List<Follow>>> call({int page = 1, int limit = 10}) async {
    return await repository.getMyFollowers(page: page, limit: limit);
  }
}
