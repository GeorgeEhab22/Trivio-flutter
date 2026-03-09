import 'package:auth/core/errors/failure.dart';
import 'package:auth/core/validator.dart';
import 'package:auth/domain/repositories/post_repo.dart';
import 'package:dartz/dartz.dart';

class RemoveReactionFromPostUseCase {
  final PostRepo repo;

  RemoveReactionFromPostUseCase(this.repo);

  Future<Either<Failure, void>> call({
    required String postId,
    String? reactionId,
  }) async {
    if (postId.trim().isEmpty) {
      return const Left(ValidationFailure('Post ID is required'));
    }
    if (!Validator.isValidId(postId)) {
      return const Left(ValidationFailure('Invalid Post ID'));
    }
    final trimmedReactionId = reactionId?.trim();
    if (trimmedReactionId != null &&
        trimmedReactionId.isNotEmpty &&
        !Validator.isValidId(trimmedReactionId)) {
      return const Left(ValidationFailure('Invalid Reaction ID'));
    }

    return await repo.removeReactionFromPost(
      postId: postId,
      reactionId: trimmedReactionId,
    );
  }
}
