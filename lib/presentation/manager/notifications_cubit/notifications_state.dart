import 'package:equatable/equatable.dart';
import '../../../domain/entities/notification.dart';

abstract class NotificationListItem extends Equatable {
  const NotificationListItem();
}

class NotificationHeaderItem extends NotificationListItem {
  final String title;
  const NotificationHeaderItem(this.title);

  @override
  List<Object> get props => [title];
}

class NotificationDataItem extends NotificationListItem {
  final NotificationEntity notification;
  const NotificationDataItem(this.notification);

  @override
  List<Object> get props => [notification];
}

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationListItem> items;
  final bool hasReachedMax;
  final Set<String> newNotificationIds;

  const NotificationLoaded({
    required this.items,
    this.hasReachedMax = false,
    this.newNotificationIds = const {},
  });

  int get newCount => newNotificationIds.length;

  NotificationLoaded copyWith({
    List<NotificationListItem>? items,
    bool? hasReachedMax,
    Set<String>? newNotificationIds,
  }) {
    return NotificationLoaded(
      items: items ?? this.items,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      newNotificationIds: newNotificationIds ?? this.newNotificationIds,
    );
  }

  @override
  List<Object> get props => [
    items,
    hasReachedMax,
    newNotificationIds,
    newNotificationIds.length,
  ];
}

class NotificationError extends NotificationState {
  final String message;
  const NotificationError(this.message);

  @override
  List<Object> get props => [message];
}
