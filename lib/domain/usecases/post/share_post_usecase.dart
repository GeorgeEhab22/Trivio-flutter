import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/repositories/post_repo.dart';
import 'package:dartz/dartz.dart';

class SharePostUseCase {
  final PostRepo repo;

  SharePostUseCase(this.repo);

  Future<Either<Failure, Post>> call({
    required String postId,
    required String type,
    String? caption,     
  }) async {
    if (postId.trim().isEmpty) {
      return const Left(ValidationFailure('Post ID is required'));
    }
    return await repo.sharePost(
      postId: postId,
      type: type,
      caption: caption,
    );
  }
}