import 'package:auth/core/errors/failure.dart';
import 'package:auth/core/validator.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/repositories/post_repo.dart';
import 'package:dartz/dartz.dart';

class GetPostUseCase {
  final PostRepo repo;

  GetPostUseCase(this.repo);

  Future<Either<Failure, Post>> call(String postId) async {
    if (postId.trim().isEmpty) {
      return const Left(ValidationFailure('Post ID is required'));
    }

    if (!Validator.isValidId(postId)) {
      return const Left(ValidationFailure('Invalid Post ID'));
    }

    return await repo.getPost(postId);
  }
}
