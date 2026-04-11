import 'package:dio/dio.dart';
import 'package:auth/common/api_endpoints.dart';
import 'package:auth/common/functions/handle_dio_error.dart';
import 'package:auth/core/json_parser.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/models/post_model.dart';
import 'package:auth/data/models/reaction_model.dart';
import 'package:auth/domain/entities/reaction.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/api_service.dart';

abstract class PostsRemoteDataSource {
  Future<PostModel> createPost({
    String? caption,
    List<XFile>? media,
    required String type,
    List<String>? tags,
    bool? shownTags,
  });
  Future<List<PostModel>> fetchPosts({int limit = 20});
  Future<PostModel> fetchSinglePost(String postId);
  Future<PostModel> editPost({
    required String postId,
    String? newCaption,
    String? newType,
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
  Future<String?> reactToPost({
    required String postId,
    required String reactionType,
    bool isUpdate = false,
    String? reactionId,
  });
  Future<void> removeReactionFromPost({
    required String postId,
    String? reactionId,
  });
  Future<List<Reaction>> fetchAllPostReactions({
    required String postId,
    int limit = 10,
    int maxPages = 20,
  });
  Future<List<PostModel>> searchPosts(String query);
  Future<void> submitWatchedPosts(List<String> postIds);
  //reels
  Future<List<PostModel>> getReels({int page = 1});
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
    if (token == null) throw AuthException('No auth token found');
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  @override
  Future<List<PostModel>> fetchPosts({int limit = 20}) async {
    try {
      final response = await api.get(
        "${ApiEndpoints.fetchPosts}?limit=$limit",
        options: _getAuthOptions(),
      );
      final List? postsRaw =
          response['data']?['posts'] ?? response['data']?['data'];
      if (postsRaw == null) return [];

      return postsRaw
          .whereType<Map<String, dynamic>>()
          .map((json) => PostModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error fetching posts: $e');
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
      final data = response['data'];
      final Map<String, dynamic> postJson = data['post'];
      postJson['userReact'] = data['userReact'];
      return PostModel.fromJson(postJson);
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<PostModel> createPost({
    String? caption,
    List<XFile>? media,
    required String type,
    List<String>? tags,
    bool? shownTags,
  }) async {
    try {
      final formData = FormData.fromMap({
        'caption': caption ?? '',
        'type': type.toLowerCase(),
        'shownTags': (shownTags ?? false).toString(),
      });

      if (media != null && media.isNotEmpty) {
        for (var file in media) {
          if (kIsWeb) {
            final bytes = await file.readAsBytes();
            formData.files.add(
              MapEntry(
                'media',
                MultipartFile.fromBytes(bytes, filename: file.name),
              ),
            );
          } else {
            formData.files.add(
              MapEntry(
                'media',
                await MultipartFile.fromFile(file.path, filename: file.name),
              ),
            );
          }
        }
      }

      if (tags != null && tags.isNotEmpty) {
        for (var i = 0; i < tags.length; i++) {
          formData.fields.add(MapEntry('tags[$i]', tags[i]));
        }
      }

      final response = await api.post(
        ApiEndpoints.createPost,
        data: formData,
        options: _getAuthOptions(),
      );
      return PostModel.fromJson(response);
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<String?> reactToPost({
    required String postId,
    required String reactionType,
    bool isUpdate = false,
    String? reactionId,
  }) async {
    final endpoint = ApiEndpoints.reactionsOnPost(postId);

    try {
      final response = await api.post(
        endpoint,
        data: {'reaction': reactionType},
        options: _getAuthOptions(),
      );
      return JsonParser.parseId(response['data']?['reaction']);
    } on DioException catch (e) {
      final msg = e.response?.data?['message']?.toString().toLowerCase() ?? '';
      if (msg.contains('already reacted') || msg.contains('use patch')) {
        return reactToPost(
          postId: postId,
          reactionType: reactionType,
          isUpdate: true,
          reactionId: reactionId,
        );
      }
      errorHandler.handleDioError(e);
      rethrow;
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<void> removeReactionFromPost({
    required String postId,
    String? reactionId,
  }) async {
    try {
      final normalizedId = JsonParser.parseId(reactionId);
      final url = (normalizedId != null && !normalizedId.startsWith('local-'))
          ? ApiEndpoints.reactionById(normalizedId)
          : ApiEndpoints.reactionsOnPost(postId);

      await api.delete(url, options: _getAuthOptions());
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<List<Reaction>> fetchAllPostReactions({
    required String postId,
    int limit = 10,
    int maxPages = 20,
  }) async {
    try {
      final response = await api.get(
        ApiEndpoints.reactionsOnPost(postId),
        options: _getAuthOptions(),
      );

      final List? items = response['data']['data'];

      if (items == null) return [];

      return items
          .whereType<Map<String, dynamic>>()
          .map((item) => ReactionModel.fromJson(item).toEntity())
          .toList();
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<PostModel> editPost({
    required String postId,
    String? newCaption,
    String? newType,
  }) async {
    try {
      final response = await api.patch(
        "${ApiEndpoints.editPost}/$postId",
        data: {'caption': newCaption},
        options: _getAuthOptions(),
      );
      return PostModel.fromJson(response);
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
        options: _getAuthOptions(),
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
        data: {'userId': userId, 'content': additionalContent},
        options: _getAuthOptions(),
      );
      final data = response['data'];
      final target = data is List ? data.first : data;
      return PostModel.fromJson(target);
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
        options: _getAuthOptions(),
      );
      final data = response['data'];
      final target = data is List ? data.first : data;
      return PostModel.fromJson(target);
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
        options: _getAuthOptions(),
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
        options: _getAuthOptions(),
      );
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<List<PostModel>> searchPosts(String query) async {
    try {
      final response = await api.get("${ApiEndpoints.searchPosts}?q=$query");
      final List data = response['data'] ?? [];
      return data
          .whereType<Map<String, dynamic>>()
          .map((e) => PostModel.fromJson(e))
          .toList();
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<void> submitWatchedPosts(List<String> postIds) async {
    try {
      await api.post(
        ApiEndpoints.submitWatchedPosts,
        data: {'postsID': postIds},
        options: _getAuthOptions(),
      );
    } catch (e) {
      debugPrint('[WatchedPosts] remote error: $e');
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  //reels
 @override
  Future<List<PostModel>> getReels({int page = 1}) async {
    try {
      final response = await api.get(
        "${ApiEndpoints.reels}?page=$page",
        options: _getAuthOptions(),
      );
      final List<dynamic> dataList = response['data']['reels'] ?? [];

      return dataList.map((e) => PostModel.fromJson(e)).toList();
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }
}
