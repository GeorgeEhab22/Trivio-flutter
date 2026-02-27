import 'package:auth/common/api_endpoints.dart';
import 'package:auth/common/functions/handle_dio_error.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/models/comment_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/api_service.dart';

abstract class CommentsRemoteDataSource {
  Future<List<CommentModel>> getComments(
    String postId, {
    int? page,
    int? limit,
    String? sort,
    String? fields,
    String? keyword,
  });
  Future<CommentModel> getComment(String commentId);

  Future<CommentModel> addComment({
    required String postId,
    required String text,
    String? parentCommentId,
  });

  Future<void> deleteComment(String commentId);

  Future<CommentModel> editComment({
    required String commentId,
    required String newContent,
  });

  Future<List<CommentModel>> getReplies(
    String parentCommentId, {
    int? page,
    int? limit,
    String? sort,
    String? fields,
    String? keyword,
  });

  Future<CommentModel> reactToComment({
    required String commentId,
    required String userId,
    required String reactionType,
  });

  Future<CommentModel> removeReactionFromComment({
    required String commentId,
    required String userId,
  });

  Future<CommentModel> mentionUsersInComment({
    required String commentId,
    required List<String> mentionedUserIds,
  });
}

class CommentsRemoteDataSourceImpl implements CommentsRemoteDataSource {
  final ApiService api;
  final SharedPreferences prefs;
  final ErrorHandler errorHandler;

  CommentsRemoteDataSourceImpl({
    required this.api,
    required this.prefs,
    required this.errorHandler,
  });

  Options _getAuthOptions() {
    final token = prefs.getString('auth_token');
    if (token == null || token.isEmpty) {
      throw AuthException('User not authenticated');
    }
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  @override
  Future<List<CommentModel>> getComments(
    String postId, {
    int? page,
    int? limit,
    String? sort,
    String? fields,
    String? keyword,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (page != null) queryParams["page"] = page;
      if (limit != null) queryParams["limit"] = limit;
      if (sort != null && sort.trim().isNotEmpty) queryParams["sort"] = sort;
      if (fields != null && fields.trim().isNotEmpty) {
        queryParams["fields"] = fields;
      }
      if (keyword != null && keyword.trim().isNotEmpty) {
        queryParams["keyword"] = keyword;
      }

      final response = await api.get(
        "${ApiEndpoints.fetchPosts}/$postId/comments",
        query: queryParams.isEmpty ? null : queryParams,
        options: _getAuthOptions(),
      );

      final comments =
          _extractListPayload(response["data"]) ??
          _extractListPayload(response);
      if (comments is! List) {
        return [];
      }

      return _parseCommentsAndReplies(comments);
    } on AuthException {
      rethrow;
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  List<CommentModel> _parseCommentsAndReplies(
    List<dynamic> rawItems, {
    String? forcedParentId,
  }) {
    final byId = <String, CommentModel>{};
    final noId = <CommentModel>[];

    void collect(Map<String, dynamic> item, {String? forcedParentId}) {
      final normalized = Map<String, dynamic>.from(item);
      final parent =
          normalized['parentCommentId'] ??
          normalized['parentId'] ??
          normalized['parent'] ??
          normalized['parentComment'];
      if (forcedParentId != null &&
          (parent == null || parent.toString().trim().isEmpty)) {
        normalized['parentCommentId'] = forcedParentId;
      }

      final model = CommentModel.fromJson(normalized);
      if (model.id.trim().isEmpty) {
        noId.add(model);
      } else {
        byId[model.id] = model;
      }

      final nestedCandidates = [
        normalized['replies'],
        normalized['repliesList'],
        normalized['children'],
      ];
      for (final nested in nestedCandidates) {
        if (nested is List) {
          for (final reply in nested.whereType<Map<String, dynamic>>()) {
            collect(reply, forcedParentId: model.id);
          }
        }
      }
    }

    for (final item in rawItems.whereType<Map<String, dynamic>>()) {
      collect(item, forcedParentId: forcedParentId);
    }

    return [...byId.values, ...noId];
  }

  @override
  Future<CommentModel> getComment(String commentId) async {
    try {
      final response = await api.get(
        "${ApiEndpoints.getComment}/$commentId",
        options: _getAuthOptions(),
      );

      final data = response["data"];
      final commentData = data is Map<String, dynamic> ? data["comment"] : data;
      if (commentData is! Map<String, dynamic>) {
        throw ServerException("Invalid comment response");
      }

      return CommentModel.fromJson(commentData);
    } on AuthException {
      rethrow;
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<CommentModel> addComment({
    required String postId,
    required String text,
    String? parentCommentId,
  }) async {
    try {
      final requestBody = <String, dynamic>{"text": text};
      final bool isReply =
          parentCommentId != null && parentCommentId.isNotEmpty;

      final response = isReply
          ? await api.post(
              "${ApiEndpoints.addReplyToComment}/$parentCommentId/replies",
              data: requestBody,
              options: _getAuthOptions(),
            )
          : await api.post(
              "${ApiEndpoints.fetchPosts}/$postId/comments",
              data: requestBody,
              options: _getAuthOptions(),
            );

      final data = response["data"];
      final commentData = data is Map<String, dynamic>
          ? (isReply ? data["reply"] : data["comment"])
          : data;
      if (commentData is! Map<String, dynamic>) {
        throw ServerException("Invalid comment response");
      }

      return CommentModel.fromJson(commentData);
    } on AuthException {
      rethrow;
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<void> deleteComment(String commentId) async {
    try {
      await api.delete(
        "${ApiEndpoints.deleteComment}/$commentId",
        options: _getAuthOptions(),
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<CommentModel> editComment({
    required String commentId,
    required String newContent,
  }) async {
    try {
      final response = await api.put(
        "${ApiEndpoints.editComment}/$commentId",
        data: {"text": newContent},
        options: _getAuthOptions(),
      );

      final data = response["data"];
      final commentData = data is Map<String, dynamic> ? data["comment"] : data;
      if (commentData is! Map<String, dynamic>) {
        throw ServerException("Invalid comment response");
      }

      return CommentModel.fromJson(commentData);
    } on AuthException {
      rethrow;
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<List<CommentModel>> getReplies(
    String parentCommentId, {
    int? page,
    int? limit,
    String? sort,
    String? fields,
    String? keyword,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (page != null) queryParams["page"] = page;
      if (limit != null) queryParams["limit"] = limit;
      if (sort != null && sort.trim().isNotEmpty) queryParams["sort"] = sort;
      if (fields != null && fields.trim().isNotEmpty) {
        queryParams["fields"] = fields;
      }
      if (keyword != null && keyword.trim().isNotEmpty) {
        queryParams["keyword"] = keyword;
      }

      final response = await api.get(
        "${ApiEndpoints.getReplies}/$parentCommentId/replies",
        options: _getAuthOptions(),
      );

      final replies =
          _extractListPayload(response["data"]) ??
          _extractListPayload(response);
      if (replies is! List) {
        return [];
      }

      return _parseCommentsAndReplies(replies, forcedParentId: parentCommentId);
    } on AuthException {
      rethrow;
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  List<dynamic>? _extractListPayload(dynamic source) {
    if (source == null) {
      return null;
    }

    final queue = <dynamic>[source];
    final seen = <int>{};

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);
      if (current == null) {
        continue;
      }

      if (current is List) {
        final hasMapItems = current.any((item) => item is Map);
        if (hasMapItems) {
          return current;
        }
      }

      if (current is Map) {
        final identity = identityHashCode(current);
        if (seen.contains(identity)) {
          continue;
        }
        seen.add(identity);

        for (final key in const [
          'data',
          'comments',
          'replies',
          'repliesList',
          'items',
          'results',
        ]) {
          final candidate = current[key];
          if (candidate is List && candidate.any((item) => item is Map)) {
            return candidate;
          }
        }

        for (final value in current.values) {
          if (value is Map || value is List) {
            queue.add(value);
          }
        }
      }
    }

    return null;
  }

  @override
  Future<CommentModel> reactToComment({
    required String commentId,
    required String userId,
    required String reactionType,
  }) async {
    try {
      final response = await api.post(
        "${ApiEndpoints.reactToComment}$commentId",
        data: {"userId": userId, "reactionType": reactionType},
        options: _getAuthOptions(),
      );

      return CommentModel.fromJson(response["data"][0]);
    } on AuthException {
      rethrow;
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<CommentModel> removeReactionFromComment({
    required String commentId,
    required String userId,
  }) async {
    try {
      final response = await api.delete(
        "${ApiEndpoints.removeReactionFromComment}$commentId",
        data: {"userId": userId},
        options: _getAuthOptions(),
      );

      return CommentModel.fromJson(response["data"][0]);
    } on AuthException {
      rethrow;
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<CommentModel> mentionUsersInComment({
    required String commentId,
    required List<String> mentionedUserIds,
  }) async {
    try {
      final response = await api.post(
        "${ApiEndpoints.mentionUsersInComment}$commentId",
        data: {"mentionedUserIds": mentionedUserIds},
        options: _getAuthOptions(),
      );

      return CommentModel.fromJson(response["data"][0]);
    } on AuthException {
      rethrow;
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }
}
