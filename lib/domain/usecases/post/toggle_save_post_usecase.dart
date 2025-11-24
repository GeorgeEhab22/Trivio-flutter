import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/repositories/post_repo.dart';
import 'package:dartz/dartz.dart';

class ToggleSavePostUseCase {
  final PostRepository repository;

  ToggleSavePostUseCase(this.repository);

  Future<Either<Failure, Post>> call({
    required String postId,
    required String userId,
  }) async {
    if (postId.trim().isEmpty) {
      return const Left(ValidationFailure('Post ID is required'));
    }

    if (userId.trim().isEmpty) {
      return const Left(ValidationFailure('User ID is required'));
    }

    return await repository.toggleSavePost(
      postId: postId,
      userId: userId,
    );
  }
}
