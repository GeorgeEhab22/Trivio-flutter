import 'package:auth/common/api_endpoints.dart';
import 'package:auth/common/functions/handle_dio_error.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/models/notification_model.dart';
import 'package:auth/domain/entities/notification_type.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/api_service.dart';
//TODO: remove dummy data and uncomment api calls(correct api calls)
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
    await Future.delayed(const Duration(seconds: 1));

    if (page! > 3) return [];

    return List.generate(limit!, (index) {
      final id = 'dummy_${page}_$index';
      
      final hoursToSubtract = (page - 1) * 24 + (index * 4); 
      final time = DateTime.now().subtract(Duration(hours: hoursToSubtract));

      NotificationType type;
      String senderName;
      String? content;
      
      if (index % 4 == 0) {
        type = NotificationType.matchAlert;
        senderName = 'Al Ahly 2 - 0 Zamalek';
        content = 'Match finished. Check the highlights!';
      } else if (index % 4 == 1) {
        type = NotificationType.postReact;
        senderName = 'Omar';
        content = null;
      } else if (index % 4 == 2) {
        type = NotificationType.postComment;
        senderName = 'Ali';
        content = 'Great post, totally agree!';
      } else {
        type = NotificationType.followUser;
        senderName = 'Sara';
        content = null;
      }

      return NotificationModel(
        id: id,
        receiverId: 'my_user_id',
        senderId: 'sender_$index',
        senderName: senderName,
        senderAvatar: 'https://picsum.photos/500', 
        type: type,
        content: content,
        isRead: index % 3 == 0, 
        createdAt: time,
      );
    });
    // try {
    //   final response = await api.get(
    //     ApiEndpoints.notifications, 
    //     query: {
    //       "page": page,
    //       "limit": limit,
    //     }..removeWhere((k, v) => v == null),
    //     options: _getAuthOptions(),
    //   );

    //   final List? notifications = response["data"] is List
    //       ? response["data"]
    //       : response["data"]?["notifications"] ?? response["data"]?["data"];
          
    //   if (notifications == null) return [];

    //   return notifications
    //       .whereType<Map<String, dynamic>>()
    //       .map((json) => NotificationModel.fromJson(json))
    //       .toList();
    // } catch (e) {
    //   errorHandler.handleDioError(e);
    //   rethrow;
    // }
  }

  @override
  Future<void> openNotification(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    print("✅ [Mock API]: Notification $notificationId marked as read on server!");
  
    // try {
    //   await api.patch(
    //     "${ApiEndpoints.notifications}/$notificationId/read",
    //     options: _getAuthOptions(),
    //   );
    // } catch (e) {
    //   errorHandler.handleDioError(e);
    //   rethrow;
    // } 
  }
}