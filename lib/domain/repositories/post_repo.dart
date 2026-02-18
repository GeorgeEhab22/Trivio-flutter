import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

abstract class PostRepo {
  Future<Either<Failure, Post>> createPost({
    String? caption,
    List<XFile>? media,
    required String type,
  });

  Future<Either<Failure, Post>> getPost(String postId);

  Future<Either<Failure, List<Post>>> fetchPosts({
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, Post>> commentOnPost({
    required String postId,
    required String userId,
    required String comment,
  });

  Future<Either<Failure, Post>> editPost({
    required String postId,
    String? newCaption,
    String? newType,
  });

  Future<Either<Failure, Post>> sharePost({
    required String postId,
    required String userId,
    String? additionalContent,
  });

  Future<Either<Failure, Post>> toggleSavePost({
    required String postId,
    required String userId,
  });

  Future<Either<Failure, void>> reportPost({
    required String postId,
    required String userId,
    required String reason,
  });

  Future<Either<Failure, void>> toggleFollowUser({
    required String followerId,
    required String followeeId,
  });

  Future<Either<Failure, void>> deletePost(String postId);

  Future<Either<Failure, Post>> reactToPost({
    required String postId,
    required String userId,
    required ReactionType reactionType,
  });

  Future<Either<Failure, Post>> removeReactionFromPost({
    required String postId,
    required String userId,
  });

  Future<Either<Failure, List<Post>>> searchPosts(String query);
}
