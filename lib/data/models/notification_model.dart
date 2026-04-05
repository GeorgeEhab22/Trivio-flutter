import '../../core/json_parser.dart';
import '../../domain/entities/notification.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.receiverId,
    required super.senderId,
    required super.senderName,
    super.senderAvatar,
    required super.type,
    super.content,
    super.isRead,
    required super.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final dynamic senderRaw = json['sender'] ?? json['actor'];
    final bool isSenderPopulated = senderRaw is Map<String, dynamic>;

    return NotificationModel(
      id: JsonParser.parseId(json['_id'] ?? json['id']) ?? '',
      receiverId:
          JsonParser.parseId(json['receiverId'] ?? json['userId']) ?? '',
      senderId: JsonParser.parseId(senderRaw) ?? '',

      senderName: isSenderPopulated
          ? JsonParser.parseString(senderRaw['username'] ?? senderRaw['name'])
          : JsonParser.parseString(json['senderName']),

      senderAvatar: isSenderPopulated
          ? JsonParser.parseString(
              senderRaw['profilePicture'] ?? senderRaw['avatar'],
            )
          : JsonParser.parseString(json['senderAvatar']),

      type: JsonParser.parseNotificationType(
        json['type'] ?? json['notificationType'],
      ),
      content: JsonParser.parseString(json['content'] ?? json['message']),
      isRead: json['isRead'] == true,
      createdAt: JsonParser.parseDate(json['createdAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'receiverId': receiverId,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'type': type.name, 
      'content': content,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  NotificationEntity toEntity() => NotificationEntity(
    id: id,
    receiverId: receiverId,
    senderId: senderId,
    senderName: senderName,
    senderAvatar: senderAvatar,
    type: type,
    content: content,
    isRead: isRead,
    createdAt: createdAt,
  );

  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      receiverId: entity.receiverId,
      senderId: entity.senderId,
      senderName: entity.senderName,
      senderAvatar: entity.senderAvatar,
      type: entity.type,
      content: entity.content,
      isRead: entity.isRead,
      createdAt: entity.createdAt,
    );
  }
}
