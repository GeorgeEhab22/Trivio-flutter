import 'package:dio/dio.dart';
import 'package:auth/common/api_endpoints.dart';
import 'package:auth/common/functions/handle_dio_error.dart';
import 'package:auth/data/core/error/exceptions.dart'; // Ensure this is imported for AuthException
import 'package:auth/data/models/post_model.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/api_service.dart';

abstract class PostsRemoteDataSource {
  Future<PostModel> createPost({
    String? caption,
    List<XFile>? media, 
    required String type,
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

  Options _getAuthOptions() {
    final token = prefs.getString('auth_token');
    if (token == null) {
      throw AuthException('No auth token found');
    }
    return Options(headers: {
      'Authorization': 'Bearer $token',
    });
  }

  @override
  Future<PostModel> createPost({
    String? caption,
    List<XFile>? media,
    required String type,
  }) async {
    try {
      final token = prefs.getString('auth_token');
      if (token == null) {
        throw AuthException('No auth token found');
      }
      type = type.toLowerCase();

      final formData = FormData.fromMap({
        'caption': caption??'',
        'type': type,
      });

      if (media != null) {
        for (var file in media) {
          MultipartFile multipartFile;

          if (kIsWeb) {
            final bytes = await file.readAsBytes();
            multipartFile = MultipartFile.fromBytes(
              bytes,
              filename: file.name,
            );
          } else {
            multipartFile = await MultipartFile.fromFile(
              file.path,
              filename: file.name,
            );
          }

          formData.files.add(MapEntry('media', multipartFile));
        }
      }

      final response = await api.post(
        ApiEndpoints.createPost,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return PostModel.fromJson(response['data']['post']);
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
    final response = await api.get(
      "${ApiEndpoints.fetchSinglePost}/$postId",
      options: _getAuthOptions(), 
    );
    
    return PostModel.fromJson(response['data']['post']);
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
        options: _getAuthOptions(), // Added Auth
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
      await api.delete(
        "${ApiEndpoints.deletePost}/$postId",
        options: _getAuthOptions(), // Added Auth
      );
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
        options: _getAuthOptions(), // Added Auth
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
        options: _getAuthOptions(), // Added Auth
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
        options: _getAuthOptions(), // Added Auth
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
        options: _getAuthOptions(), // Added Auth
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
        options: _getAuthOptions(), // Added Auth
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
        options: _getAuthOptions(), // Added Auth
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