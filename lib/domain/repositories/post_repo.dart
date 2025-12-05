import 'dart:io';

import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:dartz/dartz.dart';

abstract class PostRepository {
  // 13 use case untill now

  Future<Either<Failure, Post>> createPost({
    required String userId,
    required String content,
    File? image,
    File? video,
    List<String>? tags,
  });
Future<Either<Failure, Post>> fetchSinglePost(String postId);
  
  // limit ??
  Future<Either<Failure, List<Post>>> fetchPosts({int page = 1, int limit = 20});

  Future<Either<Failure, Post>> commentOnPost({
    required String postId,
    required String userId,
    required String comment,
  });

  Future<Either<Failure, Post>> editPost({
    required String postId,
    required String userId,
    required String newContent,
    String? newImageUrl,
    String? newVideoUrl,
    List<String>? newTags,
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
   // required String reason,
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
