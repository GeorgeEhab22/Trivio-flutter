import 'package:auth/core/errors/failure.dart';
import 'package:auth/core/validator.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/repositories/post_repo.dart';
import 'package:dartz/dartz.dart';

class CreatePostUseCase {
  final PostRepository repository;

  // max post content
  static const int maxContentLength = 500;

  CreatePostUseCase(this.repository);

  Future<Either<Failure, Post>> call({
    required String userId,
    required String content,
    String? imageUrl,
    String? videoUrl,
    List<String>? tags,
  }) async {
    if (userId.trim().isEmpty) {
      return const Left(ValidationFailure('User ID is required'));
    }

    if (!Validator.isValidId(userId)) {
      return const Left(ValidationFailure('Invalid User ID'));
    }

    final trimmedContent = content.trim();

    if (trimmedContent.isEmpty &&
        (imageUrl == null || imageUrl.isEmpty) &&
        (videoUrl == null || videoUrl.isEmpty)) {
      return const Left(
        ValidationFailure('Post must have text or an image or video'),
      );
    }

    if (trimmedContent.length > maxContentLength) {
      return Left(
        ValidationFailure(
          'Post content cannot exceed $maxContentLength characters',
        ),
      );
    }

    if (imageUrl != null &&
        imageUrl.isNotEmpty &&
        !Validator.isValidUrl(imageUrl)) {
      return const Left(ValidationFailure('Invalid image URL'));
    }

    if (videoUrl != null &&
        videoUrl.isNotEmpty &&
        !Validator.isValidUrl(videoUrl)) {
      return const Left(ValidationFailure('Invalid video URL'));
    }

    return await repository.createPost(
      userId: userId,
      content: trimmedContent,
      imageUrl: imageUrl,
      videoUrl: videoUrl,
      tags: tags,
    );
  }
}
