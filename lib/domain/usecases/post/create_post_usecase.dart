import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/repositories/post_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostUseCase {
  final PostRepository repository;

  static const int maxContentLength = 500;

  CreatePostUseCase(this.repository);

  Future<Either<Failure, Post>> call({
    String? caption,
    List<XFile>? media, 
    required String type,
  }) async {
    final trimmedCaption = caption?.trim() ?? '';

    final bool hasMedia = media != null && media.isNotEmpty;
 

    if (trimmedCaption.isEmpty && !hasMedia) {
      return const Left(
        ValidationFailure('Post must have text or an image or video'),
      );
    }

    if (trimmedCaption.length > maxContentLength) {
      return Left(
        ValidationFailure(
          'Post content cannot exceed $maxContentLength characters',
        ),
      );
    }


    return await repository.createPost(
      caption: trimmedCaption,
      media: media??[], 
      type: type,
    );
  }
}