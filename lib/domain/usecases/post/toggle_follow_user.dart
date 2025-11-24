import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/post_repo.dart';
import 'package:dartz/dartz.dart';

class ToggleFollowUserUseCase {
  final PostRepository repository;

  ToggleFollowUserUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String followedUserId,
    required String followerUserId,
  }) async {
    if (followedUserId.trim().isEmpty) {
      return const Left(ValidationFailure('Followed user ID is required'));
    }

    if (followerUserId.trim().isEmpty) {
      return const Left(ValidationFailure('Follower user ID is required'));
    }

    return await repository.toggleFollowUser(
      followerId: followerUserId,
      followeeId: followedUserId,
    );
  }
}
