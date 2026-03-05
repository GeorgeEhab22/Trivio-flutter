import 'package:dio/dio.dart';
import 'package:auth/common/api_endpoints.dart';
import 'package:auth/common/functions/handle_dio_error.dart';
import 'package:auth/data/core/error/exceptions.dart'; // Ensure this is imported for AuthException
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
  });

  Future<List<PostModel>> fetchPosts({int page = 1, int limit = 20});

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
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  String? _cleanId(dynamic value) {
    if (value == null) {
      return null;
    }
    final parsed = value.toString().trim();
    if (parsed.isEmpty || parsed == 'null') {
      return null;
    }
    return parsed;
  }

  String? _firstNonEmpty(Iterable<dynamic> values) {
    for (final value in values) {
      final parsed = _cleanId(value);
      if (parsed != null) {
        return parsed;
      }
    }
    return null;
  }

  String? _readId(dynamic value) {
    if (value is Map<String, dynamic>) {
      final direct = _firstNonEmpty([
        value['_id'],
        value['id'],
        value['userId'],
        value['authorID'],
        value['sub'],
      ]);
      if (direct != null) {
        return direct;
      }
      return _firstNonEmpty([_readId(value['user']), _readId(value['data'])]);
    }

    if (value is List) {
      for (final item in value) {
        final found = _readId(item);
        if (found != null) {
          return found;
        }
      }
      return null;
    }

    return _cleanId(value);
  }

  List<Map<String, dynamic>> _extractReactionItemsFromResponse(
    Map<String, dynamic> response,
  ) {
    List<Map<String, dynamic>> asItems(dynamic raw) =>
        raw is List ? raw.whereType<Map<String, dynamic>>().toList() : const [];

    final data = response['data'];
    if (data is Map<String, dynamic>) {
      final candidates = [
        data['data'],
        data['items'],
        data['reactions'],
        if (data['data'] is Map<String, dynamic>)
          (data['data'] as Map<String, dynamic>)['data'],
      ];
      for (final candidate in candidates) {
        final items = asItems(candidate);
        if (items.isNotEmpty) {
          return items;
        }
      }
    }

    for (final candidate in [data, response['reactions']]) {
      final items = asItems(candidate);
      if (items.isNotEmpty) {
        return items;
      }
    }

    return const <Map<String, dynamic>>[];
  }

  String? _extractReactionIdFromResponse(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is! Map<String, dynamic>) {
      return null;
    }

    final dynamic reaction = data['reaction'];
    if (reaction is Map<String, dynamic>) {
      final id = _readId(reaction);
      if (id != null) {
        return id;
      }
    }

    final items = _extractReactionItemsFromResponse(response);
    if (items.isEmpty) {
      return null;
    }
    return _readId(items.first);
  }

  int _extractCommentsCountFromResponse(Map<String, dynamic> response) {
    List<dynamic> asList(dynamic value) => value is List ? value : const [];

    final data = response['data'];
    if (data is Map<String, dynamic>) {
      final direct = asList(data['data']);
      if (direct.isNotEmpty) {
        return direct.length;
      }
      final nested = data['data'];
      if (nested is Map<String, dynamic>) {
        final nestedData = asList(nested['data']);
        if (nestedData.isNotEmpty) {
          return nestedData.length;
        }
      }
    }

    final fallback = asList(response['data']);
    if (fallback.isNotEmpty) {
      return fallback.length;
    }
    return 0;
  }

  Future<int> _fetchCommentsCountForPost(String postId) async {
    try {
      final response = await api.get(
        "${ApiEndpoints.fetchPosts}/$postId/comments",
        options: _getAuthOptions(),
      );
      return _extractCommentsCountFromResponse(response);
    } catch (_) {
      return 0;
    }
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
        'caption': caption ?? '',
        'type': type,
      });

      if (media != null) {
        for (var file in media) {
          MultipartFile multipartFile;

          if (kIsWeb) {
            final bytes = await file.readAsBytes();
            multipartFile = MultipartFile.fromBytes(bytes, filename: file.name);
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
        options: Options(headers: {'Authorization': 'Bearer $token'}),
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
      if (response['data'] != null && response['data']['posts'] != null) {
        final posts = (response['data']['posts'] as List)
            .whereType<Map<String, dynamic>>()
            .toList();
        return Future.wait(
          posts.map((rawPost) async {
            final post = Map<String, dynamic>.from(rawPost);
            final postId = _cleanId(post['_id'] ?? post['id']);
            if (postId != null) {
              final commentsCount = await _fetchCommentsCountForPost(postId);
              post['commentsCount'] = commentsCount;
            }
            return PostModel.fromJson(post);
          }),
        );
      } else {
        return [];
      }
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
      final post = Map<String, dynamic>.from(
        response['data']['post'] as Map<String, dynamic>,
      );
      post['commentsCount'] = await _fetchCommentsCountForPost(postId);
      return PostModel.fromJson(post);
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
        options: _getAuthOptions(), // Added Auth
      );
      return PostModel.fromJson(response['data']['post']);
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
        data: {'userId': userId, 'content': additionalContent},
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
  Future<String?> reactToPost({
    required String postId,
    required String reactionType,
    bool isUpdate = false,
    String? reactionId,
  }) async {
    final endpoint = ApiEndpoints.reactionsOnPost(postId);
    Future<String?> resolveReactionIdForUpdate() async {
      final direct = _cleanId(reactionId);
      if (direct != null && !direct.startsWith('local-')) {
        return direct;
      }
      return null;
    }

    try {
      if (isUpdate) {
        final resolvedReactionId = await resolveReactionIdForUpdate();

        if (resolvedReactionId != null && resolvedReactionId.isNotEmpty) {
          final response = await api.patch(
            ApiEndpoints.reactionById(resolvedReactionId),
            data: {'reaction': reactionType},
            options: _getAuthOptions(),
          );
          return _extractReactionIdFromResponse(response) ?? resolvedReactionId;
        }

        final response = await api.patch(
          endpoint,
          data: {'reaction': reactionType},
          options: _getAuthOptions(),
        );
        return _extractReactionIdFromResponse(response) ?? resolvedReactionId;
      } else {
        final response = await api.post(
          endpoint,
          data: {'reaction': reactionType},
          options: _getAuthOptions(),
        );
        return _extractReactionIdFromResponse(response);
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data is Map<String, dynamic>
          ? (e.response!.data['message'] ?? '').toString().toLowerCase()
          : '';
      final shouldRetryAsPatch =
          !isUpdate && errorMessage.contains('already reacted');
      final shouldRetryAsPatchById =
          isUpdate &&
          (errorMessage.contains('already reacted') ||
              errorMessage.contains('use patch to update'));

      if (shouldRetryAsPatch || shouldRetryAsPatchById) {
        final resolvedReactionId = await resolveReactionIdForUpdate();

        if (resolvedReactionId != null && resolvedReactionId.isNotEmpty) {
          final response = await api.patch(
            ApiEndpoints.reactionById(resolvedReactionId),
            data: {'reaction': reactionType},
            options: _getAuthOptions(),
          );
          return _extractReactionIdFromResponse(response) ?? resolvedReactionId;
        }

        final response = await api.patch(
          endpoint,
          data: {'reaction': reactionType},
          options: _getAuthOptions(),
        );
        return _extractReactionIdFromResponse(response);
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
    Future<String?> resolveReactionIdForUpdate() async {
      final direct = _cleanId(reactionId);
      if (direct != null && !direct.startsWith('local-')) {
        return direct;
      }
      return null;
    }

    try {
      final resolvedReactionId = await resolveReactionIdForUpdate();
      if (resolvedReactionId != null && resolvedReactionId.isNotEmpty) {
        await api.delete(
          ApiEndpoints.reactionById(resolvedReactionId),
          options: _getAuthOptions(),
        );
        return;
      }

      await api.delete(
        ApiEndpoints.reactionsOnPost(postId),
        options: _getAuthOptions(),
      );
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
      final all = <Reaction>[];

      final response = await api.get(
        ApiEndpoints.reactionsOnPost(postId),
        options: _getAuthOptions(),
      );
      final items = _extractReactionItemsFromResponse(response);

      all.addAll(items.map((item) => ReactionModel.fromJson(item).toEntity()));

      return all;
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<List<PostModel>> searchPosts(String query) async {
    try {
      final response = await api.get("${ApiEndpoints.searchPosts}?q=$query");

      final data = response['data'] as List;
      return data.map((e) => PostModel.fromJson(e)).toList();
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }
}
