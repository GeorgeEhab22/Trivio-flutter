import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/repositories/post_repo.dart';
import 'package:dartz/dartz.dart';

class CommentOnPostUseCase {
  final PostRepo repo;

  CommentOnPostUseCase(this.repo);

  Future<Either<Failure, Post>> call({
    required String postId,
    required String userId,
    required String comment,
  }) async {
    if (postId.trim().isEmpty) {
      return const Left(ValidationFailure('Post ID is required'));
    }
    if (userId.trim().isEmpty) {
      return const Left(ValidationFailure('User ID is required'));
    }
    if (comment.trim().isEmpty) {
      return const Left(ValidationFailure('Comment cannot be empty'));
    }

    return await repo.commentOnPost(
      postId: postId,
      userId: userId,
      comment: comment,
    );
  }
}
