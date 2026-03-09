import 'package:auth/common/api_endpoints.dart';
import 'package:auth/common/functions/handle_dio_error.dart';
import 'package:auth/core/json_parser.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/models/comment_model.dart';
import 'package:auth/data/models/reaction_model.dart';
import 'package:auth/domain/entities/reaction.dart';
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
  Future<String?> reactToComment({
    required String commentId,
    required String reactionType,
    bool isUpdate = false,
    String? reactionId,
  });
  Future<void> removeReactionFromComment({
    required String commentId,
    String? reactionId,
  });
  Future<CommentModel> mentionUsersInComment({
    required String commentId,
    required List<String> mentionedUserIds,
  });
  Future<List<Reaction>> fetchAllCommentReactions({
    required String commentId,
    int limit = 10,
    int maxPages = 20,
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
      final response = await api.get(
        "${ApiEndpoints.fetchPosts}/$postId/comments",
        query: {
          "page": page,
          "limit": limit,
          "sort": sort,
          "fields": fields,
          "keyword": keyword,
        }..removeWhere((k, v) => v == null),
        options: _getAuthOptions(),
      );

      final List? comments = response["data"] is List
          ? response["data"]
          : response["data"]?["comments"] ?? response["data"]?["data"];
      if (comments == null) return [];

      return comments
          .whereType<Map<String, dynamic>>()
          .map((json) => CommentModel.fromJson(json))
          .toList();
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<CommentModel> getComment(String commentId) async {
    try {
      final response = await api.get(
        "${ApiEndpoints.getComment}/$commentId",
        options: _getAuthOptions(),
      );
      final data = response["data"];
      return CommentModel.fromJson(
        data is Map<String, dynamic> ? (data["comment"] ?? data) : data,
      );
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
      final bool isReply =
          parentCommentId != null && parentCommentId.isNotEmpty;
      final url = isReply
          ? "${ApiEndpoints.addReplyToComment}/$parentCommentId/replies"
          : "${ApiEndpoints.fetchPosts}/$postId/comments";

      final response = await api.post(
        url,
        data: {"text": text},
        options: _getAuthOptions(),
      );
      final data = response["data"];
      final commentData = data is Map<String, dynamic>
          ? (isReply ? data["reply"] : data["comment"])
          : data;
      return CommentModel.fromJson(commentData);
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
      return CommentModel.fromJson(
        data is Map<String, dynamic> ? (data["comment"] ?? data) : data,
      );
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
      final response = await api.get(
        "${ApiEndpoints.getReplies}/$parentCommentId/replies",
        options: _getAuthOptions(),
      );

      final List? replies = response["data"] is List
          ? response["data"]
          : response["data"]?["replies"] ?? response["data"]?["data"];
      if (replies == null) return [];

      return replies
          .whereType<Map<String, dynamic>>()
          .map((json) => CommentModel.fromJson(json))
          .toList();
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<String?> reactToComment({
    required String commentId,
    required String reactionType,
    bool isUpdate = false,
    String? reactionId,
  }) async {
    try {
      if (isUpdate && reactionId != null && !reactionId.startsWith('local-')) {
        final response = await api.patch(
          ApiEndpoints.reactionById(reactionId),
          data: {"reaction": reactionType},
          options: _getAuthOptions(),
        );
        return JsonParser.parseId(
          response["data"]?["reaction"]?["_id"] ?? reactionId,
        );
      }

      final response = await api.post(
        ApiEndpoints.reactionsOnComment(
          commentId,
        ), 
        data: {"reaction": reactionType},
        options: _getAuthOptions(),
      );
      return JsonParser.parseId(response["data"]?["reaction"]?["_id"]);
    } on DioException catch (e) {
      final msg = e.response?.data?['message']?.toString().toLowerCase() ?? '';
      if (!isUpdate && (msg.contains('already') || msg.contains('patch'))) {
        return reactToComment(
          commentId: commentId,
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
  Future<void> removeReactionFromComment({
    required String commentId,
    String? reactionId,
  }) async {
    try {
      if (reactionId != null && !reactionId.startsWith('local-')) {
        await api.delete(
          ApiEndpoints.reactionById(reactionId),
          options: _getAuthOptions(),
        );
      } else {
        await api.delete(
          ApiEndpoints.reactionsOnComment(commentId),
          options: _getAuthOptions(),
        );
      }
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<List<Reaction>> fetchAllCommentReactions({
    required String commentId,
    int limit = 10,
    int maxPages = 20,
  }) async {
    try {
      final response = await api.get(
        ApiEndpoints.reactionsOnComment(commentId),
        options: _getAuthOptions(),
      );

      final List? items = response["data"]?["data"];
      if (items == null) return [];

      return items
          .whereType<Map<String, dynamic>>()
          .map((json) => ReactionModel.fromJson(json).toEntity())
          .toList();
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
      final data = response["data"];
      return CommentModel.fromJson(data is List ? data.first : data);
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }
}
