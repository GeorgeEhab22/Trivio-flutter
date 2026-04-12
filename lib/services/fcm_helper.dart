import 'dart:io';
import 'package:auth/domain/entities/notification.dart';
import 'package:auth/presentation/manager/notifications_cubit/notifications_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import 'package:auth/core/app_router.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:auth/presentation/notifcations/widgets/top_notification_card.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:go_router/go_router.dart';

import '../firebase_options.dart';
import '../core/app_routes.dart';
import '../data/datasource/notifications_remote_datasource.dart';
import '../injection_container.dart' as di;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class FcmHelper {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static bool get isSupported =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  static Future<void> initFCM() async {
    if (!isSupported) return;

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    _setupForegroundListener();
    await setupInteractedMessage();

    _messaging.onTokenRefresh.listen((_) => sendTokenToBackend());
  }

  static void _setupForegroundListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final context = navigatorKey.currentContext;

      final title =
          message.notification?.title ??
          message.data['title'] ??
          "New Notification";
      final body =
          message.notification?.body ??
          message.data['body'] ??
          message.data['message'] ??
          "";

      final bool isToxic =
          body.contains("violating our community guidelines") ||
          body.contains("inappropriate content");

      if (context != null && context.mounted) {
        try {
          final profileState = context.read<ProfileCubit>().state;
          if (profileState is ProfileLoaded) {
            final currentUserId = profileState.user.id;
            final senderId =
                message.data['senderId'] ??
                message.data['userId'] ??
                message.data['actorId'];

            if (senderId != null && senderId == currentUserId && !isToxic) {
              return;
            }
          }
        } catch (_) {}
      }

      try {
        //TODO: here to change notification sound
        await _audioPlayer.play(AssetSource('sounds/notificationSound.wav'));
      } catch (_) {}

      TopNotificationCard.show(
        title: title,
        body: body,
        onTap: () => _handleMessageRouting(message),
      );

      // Update cubit so the badge increments immediately in the app bar
      final entity = _parseMessageToEntity(message);
      if (entity != null && context != null && context.mounted) {
        context.read<NotificationCubit>().onPushNotificationReceived(entity);
      }
    });
  }

  static Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      Future.delayed(
        const Duration(seconds: 1),
        () => _handleMessageRouting(initialMessage),
      );
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageRouting);
  }

  static void _handleMessageRouting(RemoteMessage message) {
    final String? type = message.data['entityType'];
    final String? entityId = message.data['entityId'];
    final String? postId = message.data['postId'];
    final String? notificationId =
        message.data['id'] ?? message.data['notificationId'];

    final String? senderId =
        message.data['senderId'] ??
        message.data['userId'] ??
        message.data['actorId'];

    if (navigatorKey.currentContext == null || type == null) return;

    final context = navigatorKey.currentContext!;
    final routeType = type.toUpperCase();

    if (notificationId != null) {
      context.read<NotificationCubit>().markAsRead(notificationId);
    }

    if (routeType == 'FOLLOW') {
      final String? targetUserId = senderId ?? entityId;

      if (targetUserId != null) {
        context.push(AppRoutes.userProfileByIdPath(targetUserId));
      }
    } else if (routeType == 'REACT') {
      final targetId = postId ?? entityId;
      if (targetId != null) {
        context.push(AppRoutes.singlePostPath(targetId));
      }
    } else if (routeType == 'COMMENT') {
      final targetPostId = postId ?? entityId;
      final commentId = entityId;

      if (targetPostId != null) {
        final path = Uri(
          path: AppRoutes.singlePostPath(targetPostId),
          queryParameters: {'commentId': commentId},
        ).toString();

        context.push(path);
      }
    }
  }

  // Parses FCM data payload into a NotificationEntity so the cubit
  // can insert it into _allItems and update the badge count.
  // Returns null if the message has no usable ID (nothing to track).
  static NotificationEntity? _parseMessageToEntity(RemoteMessage message) {
    final data = message.data;
    final id = data['id'] ?? data['notificationId'];
    if (id == null) return null;

    return NotificationEntity(
      id: id,
      receiverId: data['receiverId'] ?? '',
      senderId: data['senderId'] ?? data['userId'] ?? data['actorId'] ?? '',
      senderName: data['senderName'] ?? message.notification?.title ?? '',
      senderAvatar: data['senderAvatar'],
      type: data['entityType'] ?? '',
      message:
          message.notification?.body ?? data['body'] ?? data['message'] ?? '',
      entityId: data['entityId'],
      postId: data['postId'],
      isRead: false,
      createdAt: DateTime.now(),
    );
  }

  static Future<String?> getDeviceToken() =>
      isSupported ? _messaging.getToken() : Future.value(null);

  static Future<void> sendTokenToBackend() async {
    if (!isSupported) return;

    try {
      final token = await _messaging.getToken().timeout(
        const Duration(seconds: 20),
        onTimeout: () => null,
      );

      if (token != null) {
        print("✅ SUCCESS! FCM Token: $token");
        await di.sl<NotificationRemoteDataSource>().registerFcmToken(token);
      }
    } catch (_) {}
  }
}
