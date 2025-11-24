import 'package:auth/common/api_endpoints.dart';
import 'package:auth/common/functions/handle_dio_error.dart';
import 'package:auth/data/models/comment_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/api_service.dart';

abstract class CommentsRemoteDataSource {
  Future<List<CommentModel>> getComments(String postId);

  Future<CommentModel> addComment({
    required String postId,
    required String userId,
    required String text,
    String? parentCommentId,
  });

  Future<void> deleteComment(String commentId);

  Future<CommentModel> editComment({
    required String commentId,
    required String userId,
    required String newContent,
  });

  Future<List<CommentModel>> getReplies(String parentCommentId);

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

  @override
  Future<List<CommentModel>> getComments(String postId) async {
    try {
      final response = await api.get("${ApiEndpoints.getComments}$postId");
      final data = response["data"] as List;
      return data.map((e) => CommentModel.fromJson(e)).toList();
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<CommentModel> addComment({
    required String postId,
    required String userId,
    required String text,
    String? parentCommentId,
  }) async {
    try {
      final response = await api.post(
        ApiEndpoints.addComment,
        data: {
          "postId": postId,
          "userId": userId,
          "text": text,
          "parentCommentId": parentCommentId,
        },
      );

      return CommentModel.fromJson(response["data"][0]);
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<void> deleteComment(String commentId) async {
    try {
      await api.delete("${ApiEndpoints.deleteComment}$commentId");
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<CommentModel> editComment({
    required String commentId,
    required String userId,
    required String newContent,
  }) async {
    try {
      final response = await api.patch(
        "${ApiEndpoints.editComment}$commentId",
        data: {
          "userId": userId,
          "text": newContent,
        },
      );

      return CommentModel.fromJson(response["data"][0]);
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<List<CommentModel>> getReplies(String parentCommentId) async {
    try {
      final response =
          await api.get("${ApiEndpoints.getReplies}$parentCommentId");

      final data = response["data"] as List;
      return data.map((e) => CommentModel.fromJson(e)).toList();
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
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
        data: {
          "userId": userId,
          "reactionType": reactionType,
        },
      );

      return CommentModel.fromJson(response["data"][0]);
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
        data: {
          "userId": userId,
        },
      );

      return CommentModel.fromJson(response["data"][0]);
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
      );

      return CommentModel.fromJson(response["data"][0]);
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }
}
