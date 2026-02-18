import 'package:auth/domain/repositories/follow_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:auth/domain/entities/follow.dart';
import 'package:auth/core/errors/failure.dart';

class FollowUser {
  final FollowRepo repository;

  FollowUser(this.repository);

  Future<Either<Failure, Follow>> call({required String userId}) async {
    return await repository.followUser(userId: userId);
  }
}
