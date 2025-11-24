import 'package:auth/core/errors/failure.dart';
import 'package:auth/core/validator.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/repositories/post_repo.dart';
import 'package:dartz/dartz.dart';

class EditPostUseCase {
  final PostRepository repository;

  EditPostUseCase(this.repository);

  Future<Either<Failure, Post>> call({
    required String postId,
    required String userId,
    required String newContent,
    String? newImageUrl,
    String? newVideoUrl,
  }) async {
    if (postId.trim().isEmpty) {
      return const Left(ValidationFailure('Post ID is required'));
    }
    if (!Validator.isValidId(postId)) {
      return const Left(ValidationFailure('Invalid Post ID'));
    }

    if (userId.trim().isEmpty) {
      return const Left(ValidationFailure('User ID is required'));
    }
    if (!Validator.isValidId(userId)) {
      return const Left(ValidationFailure('Invalid User ID'));
    }

    if (newContent.trim().isEmpty &&
        (newImageUrl == null || newImageUrl.isEmpty) &&
        (newVideoUrl == null || newVideoUrl.isEmpty)) {
      return const Left(
        ValidationFailure('Post must have text or media'),
      );
    }

    return await repository.editPost(
      postId: postId,
      userId: userId,
      newContent: newContent,
      newImageUrl: newImageUrl,
      newVideoUrl: newVideoUrl,
    );
  }
}
