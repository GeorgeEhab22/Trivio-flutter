import 'package:auth/common/functions/handle_dio_error.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/models/notification_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/api_service.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications({
    int? page,
    int? limit,
  });
  
  Future<void> openNotification(String notificationId);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiService api;
  final SharedPreferences prefs;
  final ErrorHandler errorHandler;

  NotificationRemoteDataSourceImpl({
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
  Future<List<NotificationModel>> getNotifications({
    int? page,
    int? limit,
  }) async {
    try {
      final response = await api.get(
        ApiEndpoints.notifications, 
        query: {
          "page": page,
          "limit": limit,
        }..removeWhere((k, v) => v == null),
        options: _getAuthOptions(),
      );

      final data = response["data"];
      final List? notifications = data != null ? data["notifications"] : null;
          
      if (notifications == null) return [];

      return notifications
          .whereType<Map<String, dynamic>>()
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<void> openNotification(String notificationId) async {
    try {
      await api.patch(
        "${ApiEndpoints.notifications}/$notificationId/read",
        options: _getAuthOptions(),
      );
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    } 
  }
}