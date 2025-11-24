import 'package:auth/core/errors/failure.dart';
import 'package:auth/core/validator.dart';
import 'package:auth/domain/entities/comment.dart';
import 'package:auth/domain/repositories/comment_repo.dart';
import 'package:dartz/dartz.dart';

class GetRepliesUseCase {
  final CommentRepository repository;

  GetRepliesUseCase(this.repository);

  Future<Either<Failure, List<Comment>>> call(String parentCommentId) async {
    if (parentCommentId.trim().isEmpty) {
      return const Left(ValidationFailure('Parent comment ID is required'));
    }
    if (!Validator.isValidId(parentCommentId)) {
      return const Left(ValidationFailure('Invalid Comment ID'));
    }

    return await repository.getReplies(parentCommentId);
  }
}
