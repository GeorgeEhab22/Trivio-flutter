import 'package:auth/core/errors/failure.dart';
import 'package:auth/core/validator.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/domain/repositories/post_repo.dart';
import 'package:dartz/dartz.dart';

class ReactToPostUseCase {
  final PostRepo repo;

  ReactToPostUseCase(this.repo);

  Future<Either<Failure, String?>> call({
    required String postId,
    required ReactionType reactionType,
    bool isUpdate = false,
    String? reactionId,
  }) async {
    if (postId.trim().isEmpty) {
      return const Left(ValidationFailure('Post ID is required'));
    }
    if (!Validator.isValidId(postId)) {
      return const Left(ValidationFailure('Invalid Post ID'));
    }

    return await repo.reactToPost(
      postId: postId,
      reactionType: reactionType,
      isUpdate: isUpdate,
      reactionId: reactionId,
    );
  }
}
