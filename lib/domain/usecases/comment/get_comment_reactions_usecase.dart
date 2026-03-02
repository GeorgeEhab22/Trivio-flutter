import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/reaction.dart';
import 'package:auth/domain/repositories/comment_repo.dart';
import 'package:dartz/dartz.dart';

class GetCommentReactionsUseCase {
  final CommentRepository repo;

  GetCommentReactionsUseCase(this.repo);

  Future<Either<Failure, List<Reaction>>> call({
    required String commentId,
    int limit = 10,
    int maxPages = 20,
  }) async {
    if (commentId.trim().isEmpty) {
      return const Left(ValidationFailure('Comment ID is required'));
    }
    return await repo.getCommentReactions(
      commentId: commentId,
      limit: limit,
      maxPages: maxPages,
    );
  }
}
