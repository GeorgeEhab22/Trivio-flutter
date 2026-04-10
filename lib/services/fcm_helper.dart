import 'dart:io';
import 'package:auth/core/app_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:go_router/go_router.dart';

import '../firebase_options.dart';
import '../main.dart';
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
      print("🔥 FCM MESSAGE RECEIVED IN FOREGROUND 🔥");
      print("🔥 Data: ${message.data}");
      print("🔥 Notification: ${message.notification?.title}");
      try {
        await _audioPlayer.play(AssetSource('sounds/notificationSound.wav'));
      } catch (e) {
        debugPrint("Notification Audio Error: $e");
      }

      if (scaffoldMessengerKey.currentState != null) {
        final title =
            message.notification?.title ??
            message.data['title'] ??
            "new notification";
        final body =
            message.notification?.body ??
            message.data['body'] ??
            message.data['message'] ??
            "";

        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF1D2228),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(body, style: const TextStyle(color: Colors.white70)),
              ],
            ),
            action: SnackBarAction(
              label: 'View',
              textColor: Colors.blueAccent,
              onPressed: () => _handleMessageRouting(message),
            ),
          ),
        );
      }else {
       print("⚠️ scaffoldMessengerKey.currentState is NULL!");
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
    final String? postId =
        message.data['postId']; 

    if (navigatorKey.currentContext == null || type == null || entityId == null)
      return;

    final context = navigatorKey.currentContext!;
    final routeType = type.toUpperCase();

    if (routeType == 'FOLLOW') {
      context.push(AppRoutes.userProfileByIdPath(entityId));
    } else if (routeType == 'REACT' || routeType == 'COMMENT') {
     
      final targetId = postId ?? entityId;
      context.push(AppRoutes.singlePostPath(targetId));
    }
  }

  static Future<String?> getDeviceToken() =>
      isSupported ? _messaging.getToken() : Future.value(null);

  static Future<void> sendTokenToBackend() async {
    if (!isSupported) return;
    try {
      final token = await getDeviceToken();
      if (token != null) {
        await di.sl<NotificationRemoteDataSource>().registerFcmToken(token);
        print("FCM Token synced with backend : $token");
      }
    } catch (e) {
      print("FCM Sync Error: $e");
    }
  }
}
