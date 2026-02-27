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
    required String text,
    String? parentCommentId,
  }) async {
    if (postId.trim().isEmpty) {
      return const Left(ValidationFailure('Post ID is required'));
    }
    if (!Validator.isValidId(postId)) {
      return const Left(ValidationFailure('Invalid Post ID'));
    }

    if (text.trim().isEmpty) {
      return const Left(ValidationFailure('Comment text is required'));
    }

    if (text.length > 1000) {
      return const Left(
        ValidationFailure('Comment too long (max 1000 characters)'),
      );
    }

    String? normalizedParentCommentId;
    if (parentCommentId != null && parentCommentId.trim().isNotEmpty) {
      if (!Validator.isValidId(parentCommentId.trim())) {
        return const Left(ValidationFailure('Invalid Parent Comment ID'));
      }
      normalizedParentCommentId = parentCommentId.trim();
    }

    return await repository.addComment(
      postId: postId.trim(),
      text: text.trim(),
      parentCommentId: normalizedParentCommentId,
    );
  }
}
