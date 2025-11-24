import 'package:auth/core/errors/failure.dart';
import 'package:auth/core/validator.dart';
import 'package:auth/domain/entities/comment.dart';
import 'package:auth/domain/repositories/comment_repo.dart';
import 'package:dartz/dartz.dart';

class AddCommentUseCase {
  final CommentRepository repository;

  AddCommentUseCase(this.repository);

  Future<Either<Failure, Comment>> call({
    required String postId,
    required String userId,
    required String text,
    String? parentCommentId,
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

    if (text.trim().isEmpty) {
      return const Left(ValidationFailure('Comment text is required'));
    }

    if (text.length > 1000) {
      return const Left(
        ValidationFailure('Comment too long (max 1000 characters)'),
      );
    }

    return await repository.addComment(
      postId: postId.trim(),
      userId: userId.trim(),
      text: text.trim(),
      parentCommentId: parentCommentId,
    );
  }
}
