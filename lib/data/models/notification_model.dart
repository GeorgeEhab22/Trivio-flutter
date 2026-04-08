import '../../domain/entities/notification.dart';
import '../../domain/entities/notification_type.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.receiverId,
    required super.senderId,
    required super.senderName,
    super.senderAvatar,
    required super.type,
    required super.message,
    required super.entityId,
    super.isRead,
    required super.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final sender = json['sender'] ?? {};

    return NotificationModel(
      id: json['_id']?.toString() ?? '',
      receiverId: json['receiver']?.toString() ?? '',
      senderId: sender['_id']?.toString() ?? '',
      senderName: sender['username']?.toString() ?? '',
      senderAvatar: sender['avatar']?.toString(),
      type: _parseType(json['entityType']?.toString()),
      message: json['message']?.toString() ?? '',
      entityId: json['entityID']?.toString() ?? '',
      isRead: json['isRead'] == true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  static NotificationType _parseType(String? type) {
    switch (type?.toUpperCase()) {
      case 'FOLLOW':
        return NotificationType.follow;
      case 'COMMENT':
        return NotificationType.comment;
      case 'REACT':
        return NotificationType.react;
      case 'MATCH':
        return NotificationType.matchAlert;
      default:
        return NotificationType.none;
    }
  }

  NotificationEntity toEntity() => NotificationEntity(
    id: id,
    receiverId: receiverId,
    senderId: senderId,
    senderName: senderName,
    senderAvatar: senderAvatar,
    type: type,
    message: message,
    entityId: entityId,
    isRead: isRead,
    createdAt: createdAt,
  );
}
