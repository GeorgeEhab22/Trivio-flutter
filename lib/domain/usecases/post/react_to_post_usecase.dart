import 'package:auth/core/errors/failure.dart';
import 'package:auth/core/validator.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/domain/repositories/post_repo.dart';
import 'package:dartz/dartz.dart';

class ReactToPostUseCase {
  final PostRepo repo;

  ReactToPostUseCase(this.repo);

  Future<Either<Failure, Post>> call({
    required String postId,
    required String userId,
    required ReactionType reactionType, // none ,goal , offside
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

    // if (reactionType.trim().isEmpty) {
    //   return const Left(ValidationFailure('Reaction type is required'));
    // }

    return await repo.reactToPost(
      postId: postId,
      userId: userId,
      reactionType: reactionType,
    );
  }
}
