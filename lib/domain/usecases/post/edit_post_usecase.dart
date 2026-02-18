import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/repositories/post_repo.dart';
import 'package:dartz/dartz.dart';

class EditPostUseCase {
  final PostRepo repo;

  EditPostUseCase(this.repo);

  Future<Either<Failure, Post>> call({
    required String postId,
    String? caption,
    String? newType,
  }) async {
    if (postId.trim().isEmpty) {
      return const Left(ValidationFailure('Post ID is required'));
    }
    return await repo.editPost(
      postId: postId,
      newCaption: caption,
      newType: newType,
    );
  }
}
