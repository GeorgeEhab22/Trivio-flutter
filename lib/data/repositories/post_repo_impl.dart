import 'package:auth/core/errors/failure.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/datasource/posts_remote_datasource.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/reaction.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/domain/repositories/post_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class PostRepositoryImpl implements PostRepo {
  final PostsRemoteDataSource remoteDataSource;

  PostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Post>> createPost({
    String? caption,
    List<XFile>? media, // Updated parameter
    required String type,
    List<String>? tags,
    bool? shownTags,
  }) async {
    try {
      // Pass the list of paths to the data source
      // Ensure your RemoteDataSource method (createPost) accepts 'filePaths'
      final model = await remoteDataSource.createPost(
        caption: caption,
        media: media ?? [], // Pass empty list if null
        type: type,
        tags: tags,
        shownTags: shownTags,
      );

      return Right(model.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(
        ServerFailure('An unexpected error occurred while creating post'),
      );
    }
  }

  @override
  Future<Either<Failure, Post>> getPost(String postId) async {
    try {
      final model = await remoteDataSource.fetchSinglePost(postId);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to fetch post'));
    }
  }

  @override
  Future<Either<Failure, List<Post>>> fetchPosts({int limit = 20}) async {
    try {
      final models = await remoteDataSource.fetchPosts(limit: limit);
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to fetch posts'));
    }
  }

  @override
  Future<Either<Failure, Post>> commentOnPost({
    required String postId,
    required String userId,
    required String comment,
  }) async {
    try {
      await remoteDataSource.reactToPost(postId: postId, reactionType: comment);
      final model = await remoteDataSource.fetchSinglePost(postId);
      return Right(model.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to add comment'));
    }
  }

  @override
  Future<Either<Failure, Post>> editPost({
    required String postId,
    String? newCaption,
    String? newType,
  }) async {
    try {
      final model = await remoteDataSource.editPost(
        postId: postId,
        newCaption: newCaption,
        newType: newType,
      );
      return Right(model.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to edit post'));
    }
  }

  @override
  Future<Either<Failure, Post>> sharePost({
    required String postId,
    required String type,     
    String? caption,    
  }) async {
    try {
      final model = await remoteDataSource.sharePost(
        postId: postId,
        type: type,     
        caption: caption, 
      );
      return Right(model.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      debugPrint("object: $e");
      return Left(
        ServerFailure('An unexpected error occurred while sharing the post'),
      );
    }
  }

  @override
  Future<Either<Failure, Post>> toggleSavePost({
    required String postId,
    required String userId,
  }) async {
    try {
      final model = await remoteDataSource.toggleSavePost(
        postId: postId,
        userId: userId,
      );
      return Right(model.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to toggle save post'));
    }
  }

  @override
  Future<Either<Failure, void>> reportPost({
    required String postId,
    required String userId,
    required String reason,
  }) async {
    try {
      await remoteDataSource.reportPost(
        postId: postId,
        userId: userId,
        reason: reason,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to report post'));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFollowUser({
    required String followerId,
    required String followeeId,
  }) async {
    try {
      await remoteDataSource.toggleFollowUser(
        followerId: followerId,
        followeeId: followeeId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to toggle follow user'));
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(String postId) async {
    try {
      await remoteDataSource.deletePost(postId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to delete post'));
    }
  }

  @override
  Future<Either<Failure, String?>> reactToPost({
    required String postId,
    required ReactionType reactionType,
    bool isUpdate = false,
    String? reactionId,
  }) async {
    try {
      final String reactionStr = reactionType.toString().split('.').last;
      final updatedReactionId = await remoteDataSource.reactToPost(
        postId: postId,
        reactionType: reactionStr,
        isUpdate: isUpdate,
        reactionId: reactionId,
      );
      return Right(updatedReactionId);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to react to post'));
    }
  }

  @override
  Future<Either<Failure, void>> removeReactionFromPost({
    required String postId,
    String? reactionId,
  }) async {
    try {
      await remoteDataSource.removeReactionFromPost(
        postId: postId,
        reactionId: reactionId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to remove reaction from post'));
    }
  }

  @override
  Future<Either<Failure, List<Reaction>>> getPostReactions({
    required String postId,
    int limit = 10,
    int maxPages = 20,
  }) async {
    try {
      final reactions = await remoteDataSource.fetchAllPostReactions(
        postId: postId,
        limit: limit,
        maxPages: maxPages,
      );
      return Right(reactions);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to fetch reactions'));
    }
  }

  @override
  Future<Either<Failure, List<Post>>> searchPosts(String query) async {
    try {
      final models = await remoteDataSource.searchPosts(query);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to search posts'));
    }
  }

  @override
  Future<Either<Failure, Unit>> submitWatchedPosts(
    List<String> watchedPosts,
  ) async {
    try {
      await remoteDataSource.submitWatchedPosts(watchedPosts);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure( e.message));
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getReels({int page = 1}) async {
    try {
      final models = await remoteDataSource.getReels(page: page);
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to fetch reels'));
    }
  }
}
