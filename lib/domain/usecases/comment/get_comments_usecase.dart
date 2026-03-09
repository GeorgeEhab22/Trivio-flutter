import 'package:auth/core/errors/failure.dart';
import 'package:auth/core/validator.dart';
import 'package:auth/domain/entities/comment.dart';
import 'package:auth/domain/repositories/comment_repo.dart';
import 'package:dartz/dartz.dart';

class GetCommentsUseCase {
  final CommentRepository repository;

  GetCommentsUseCase(this.repository);

  Future<Either<Failure, List<Comment>>> call(
    String postId, {
    int? page,
    int? limit,
    String? sort,
    String? fields,
    String? keyword,
  }) async {
    if (postId.trim().isEmpty) {
      return const Left(ValidationFailure('Post ID is required'));
    }

    if (!Validator.isValidId(postId)) {
      return const Left(ValidationFailure('Invalid Post ID format'));
    }

    if (page != null && page < 1) {
      return const Left(ValidationFailure('Page must be greater than 0'));
    }
    if (limit != null && limit < 1) {
      return const Left(ValidationFailure('Limit must be greater than 0'));
    }

    return await repository.getComments(
      postId,
      page: page,
      limit: limit,
      sort: sort,
      fields: fields,
      keyword: keyword,
    );
  }
}
