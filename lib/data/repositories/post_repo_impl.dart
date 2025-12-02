import 'package:auth/core/errors/failure.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/datasource/posts_remote_datasource.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/domain/repositories/post_repo.dart';
import 'package:dartz/dartz.dart';

class PostRepositoryImpl implements PostRepository {
  final PostsRemoteDataSource remoteDataSource;

  PostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Post>> createPost({
    required String userId,
    required String content,
    String? imageUrl,
    String? videoUrl,
    List<String>? tags,
  }) async {
    try {

      // final model = await remoteDataSource.createPost(
      //   userId: userId,
      //   content: content,
      //   imageUrl: imageUrl,
      //   videoUrl: videoUrl,
      //   tags: tags,
      // );
      // return Right(model.toEntity());

      // for testt after link with cubit
      await Future.delayed(const Duration(seconds: 1));
      final mockPost = Post(
        id: '1',
        authorId: userId,
        authorName: "Test User",
        authorImage: "",
        createdAt: DateTime.now(),
        content: "Test Content",
        isSaved:
            false,
        reactions: const [],
        comments: const [],
      );
      return Right(mockPost);
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
  Future<Either<Failure, Post>> fetchSinglePost(String postId) async {
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
  Future<Either<Failure, List<Post>>> fetchPosts({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final models = await remoteDataSource.fetchPosts(
        page: page,
        limit: limit,
      );
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
      final model = await remoteDataSource.reactToPost(
        postId: postId,
        userId: userId,
        reactionType: comment,
      );
      // If your remoteDataSource.createComment exists and returns PostModel or CommentModel, use it.
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
    required String userId,
    required String newContent,
    String? newImageUrl,
    String? newVideoUrl,
    List<String>? newTags,
  }) async {
    try {
      final model = await remoteDataSource.editPost(
        postId: postId,
        userId: userId,
        newContent: newContent,
        newImageUrl: newImageUrl,
        newVideoUrl: newVideoUrl,
        newTags: newTags,
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
    required String userId,
    String? additionalContent,
  }) async {
    try {
      final model = await remoteDataSource.sharePost(
        postId: postId,
        userId: userId,
        additionalContent: additionalContent,
      );
      return Right(model.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to share post'));
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
  Future<Either<Failure, Post>> reactToPost({
    required String postId,
    required String userId,
    required ReactionType reactionType,
  }) async {
    try {
      final String reactionStr = reactionType.toString().split('.').last;
      final model = await remoteDataSource.reactToPost(
        postId: postId,
        userId: userId,
        reactionType: reactionStr,
      );
      return Right(model.toEntity());
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
  Future<Either<Failure, Post>> removeReactionFromPost({
    required String postId,
    required String userId,
  }) async {
    try {
      final model = await remoteDataSource.removeReactionFromPost(
        postId: postId,
        userId: userId,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to remove reaction from post'));
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
}
