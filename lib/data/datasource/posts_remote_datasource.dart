import 'package:auth/common/api_endpoints.dart';
import 'package:auth/common/functions/handle_dio_error.dart';
import 'package:auth/data/models/post_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/api_service.dart';

abstract class PostsRemoteDataSource {
  Future<PostModel> createPost({
    required String userId,
    required String content,
    String? imageUrl,
    String? videoUrl,
    List<String>? tags,
  });

  Future<List<PostModel>> fetchPosts({int page = 1, int limit = 20});

  Future<PostModel> fetchSinglePost(String postId);

  Future<PostModel> editPost({
    required String postId,
    required String userId,
    required String newContent,
    String? newImageUrl,
    String? newVideoUrl,
    List<String>? newTags,
  });

  Future<void> deletePost(String postId);

  Future<PostModel> sharePost({
    required String postId,
    required String userId,
    String? additionalContent,
  });

  Future<PostModel> toggleSavePost({
    required String postId,
    required String userId,
  });

  Future<void> reportPost({
    required String postId,
    required String userId,
    required String reason,
  });

  Future<void> toggleFollowUser({
    required String followerId,
    required String followeeId,
  });

  Future<PostModel> reactToPost({
    required String postId,
    required String userId,
    required String reactionType,
  });

  Future<PostModel> removeReactionFromPost({
    required String postId,
    required String userId,
  });

  Future<List<PostModel>> searchPosts(String query);
}

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  final ApiService api;
  final SharedPreferences prefs;
  final ErrorHandler errorHandler;

  PostsRemoteDataSourceImpl({
    required this.api,
    required this.prefs,
    required this.errorHandler,
  });

  @override
  Future<PostModel> createPost({
    required String userId,
    required String content,
    String? imageUrl,
    String? videoUrl,
    List<String>? tags,
  }) async {
    try {
      final response = await api.post(
        ApiEndpoints.createPost,
        data: {
          'userId': userId,
          'content': content,
          'imageUrl': imageUrl,
          'videoUrl': videoUrl,
          'tags': tags ?? [],
        },
      );

      return PostModel.fromJson(response['data'][0]);
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<List<PostModel>> fetchPosts({int page = 1, int limit = 20}) async {
    try {
      final response = await api.get(
        "${ApiEndpoints.fetchPosts}?page=$page&limit=$limit",
      );

      final data = response['data'] as List;
      return data.map((e) => PostModel.fromJson(e)).toList();
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<PostModel> fetchSinglePost(String postId) async {
    try {
      final response = await api.get("${ApiEndpoints.fetchSinglePost}$postId");
      return PostModel.fromJson(response['data'][0]);
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<PostModel> editPost({
    required String postId,
    required String userId,
    required String newContent,
    String? newImageUrl,
    String? newVideoUrl,
    List<String>? newTags,
  }) async {
    try {
      final response = await api.patch(
        "${ApiEndpoints.editPost}$postId",
        data: {
          'userId': userId,
          'content': newContent,
          'imageUrl': newImageUrl,
          'videoUrl': newVideoUrl,
          'tags': newTags ?? [],
        },
      );

      return PostModel.fromJson(response['data'][0]);
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await api.delete("${ApiEndpoints.deletePost}$postId");
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<PostModel> sharePost({
    required String postId,
    required String userId,
    String? additionalContent,
  }) async {
    try {
      final response = await api.post(
        "${ApiEndpoints.sharePost}$postId",
        data: {
          'userId': userId,
          'content': additionalContent,
        },
      );

      return PostModel.fromJson(response['data'][0]);
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<PostModel> toggleSavePost({
    required String postId,
    required String userId,
  }) async {
    try {
      final response = await api.post(
        "${ApiEndpoints.toggleSavePost}$postId",
        data: {'userId': userId},
      );

      return PostModel.fromJson(response['data'][0]);
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<void> reportPost({
    required String postId,
    required String userId,
    required String reason,
  }) async {
    try {
      await api.post(
        "${ApiEndpoints.reportPost}$postId",
        data: {'userId': userId, 'reason': reason},
      );
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<void> toggleFollowUser({
    required String followerId,
    required String followeeId,
  }) async {
    try {
      await api.post(
        "${ApiEndpoints.toggleFollow}$followeeId",
        data: {'followerId': followerId},
      );
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<PostModel> reactToPost({
    required String postId,
    required String userId,
    required String reactionType,
  }) async {
    try {
      final response = await api.post(
        "${ApiEndpoints.addReactionToPost}$postId",
        data: {'userId': userId, 'reactionType': reactionType},
      );

      return PostModel.fromJson(response['data'][0]);
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<PostModel> removeReactionFromPost({
    required String postId,
    required String userId,
  }) async {
    try {
      final response = await api.delete(
        "${ApiEndpoints.removeReactionFromPost}$postId",
        data: {'userId': userId},
      );

      return PostModel.fromJson(response['data'][0]);
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<List<PostModel>> searchPosts(String query) async {
    try {
      final response =
          await api.get("${ApiEndpoints.searchPosts}?q=$query");

      final data = response['data'] as List;
      return data.map((e) => PostModel.fromJson(e)).toList();
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }
}
