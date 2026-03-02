import 'package:auth/core/errors/failure.dart';
import 'package:auth/core/validator.dart';
import 'package:auth/domain/entities/reaction.dart';
import 'package:auth/domain/repositories/post_repo.dart';
import 'package:dartz/dartz.dart';

class GetPostReactionsUseCase {
  final PostRepo repo;

  GetPostReactionsUseCase(this.repo);

  Future<Either<Failure, List<Reaction>>> call({
    required String postId,
    int limit = 10,
    int maxPages = 20,
  }) async {
    if (postId.trim().isEmpty) {
      return const Left(ValidationFailure('Post ID is required'));
    }

    if (!Validator.isValidId(postId)) {
      return const Left(ValidationFailure('Invalid Post ID'));
    }

    return repo.getPostReactions(
      postId: postId,
      limit: limit,
      maxPages: maxPages,
    );
  }
}
