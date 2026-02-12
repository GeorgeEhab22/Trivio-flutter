import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/follow_repo.dart';
import 'package:dartz/dartz.dart';

class UnfollowUser {
  final FollowRepo repository;

  UnfollowUser(this.repository);

  Future<Either<Failure, void>> call({required String userId}) async {
    return await repository.unfollowUser(userId: userId);
  }
}
