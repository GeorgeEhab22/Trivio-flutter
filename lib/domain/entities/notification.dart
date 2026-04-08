import 'package:equatable/equatable.dart';
import 'notification_type.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String receiverId;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final NotificationType type;
  final String message;
  final String entityId;
  final bool isRead;
  final DateTime createdAt;
  

  const NotificationEntity({
    required this.id,
    required this.receiverId,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.type,
    required this.message,
    required this.entityId,
    this.isRead = false,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        receiverId,
        senderId,
        senderName,
        senderAvatar,
        type,
        message,
        entityId,
        isRead,
        createdAt,
      ];
}