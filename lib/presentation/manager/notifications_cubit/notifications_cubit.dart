import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/usecases/notfication/get_notifications_use_case.dart';
import 'package:auth/domain/usecases/notfication/open_notification_use_case.dart';
import 'package:auth/presentation/manager/notifications_cubit/notifications_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/notification.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final OpenNotificationUseCase openNotificationUseCase;

  NotificationCubit({
    required this.getNotificationsUseCase,
    required this.openNotificationUseCase,
  }) : super(NotificationInitial());

  int _currentPage = 1;
  final int _limit = 20;
  bool _isFetching = false;
  String? _lastHeader;

  final List<NotificationListItem> _allItems = [];

  /// IDs the user has already "seen" (i.e. were present when they last opened the page)
  final Set<String> _seenIds = {};

  // ─── helpers ────────────────────────────────────────────────────────────────

  Set<String> _extractIds(List<NotificationListItem> items) {
    return items
        .whereType<NotificationDataItem>()
        .map((e) => e.notification.id)
        .toSet();
  }

  Set<String> _computeNewIds(List<NotificationListItem> items) {
    final currentIds = _extractIds(items);
    return currentIds.difference(_seenIds);
  }

  void markAllAsSeen() {
    _seenIds.addAll(_extractIds(_allItems));

    if (state is NotificationLoaded) {
      emit((state as NotificationLoaded).copyWith(newNotificationIds: {}));
    }
  }

  Future<void> fetchInitialNotifications() async {
    emit(NotificationLoading());
    _currentPage = 1;
    _lastHeader = null;
    _allItems.clear();

    final result = await getNotificationsUseCase(
      page: _currentPage,
      limit: _limit,
    );

    result.fold(
      (failure) => emit(NotificationError(_mapFailureToMessage(failure))),
      (newNotifications) {
        final processedItems = _processNewItems(newNotifications);
        _allItems.addAll(processedItems);

        emit(
          NotificationLoaded(
            items: List.from(_allItems),
            hasReachedMax: newNotifications.length < _limit,
            newNotificationIds: _computeNewIds(_allItems),
          ),
        );
      },
    );
  }

  Future<void> loadMoreNotifications() async {
    if (_isFetching ||
        (state is NotificationLoaded &&
            (state as NotificationLoaded).hasReachedMax)) {
      return;
    }
    _isFetching = true;
    _currentPage++;

    final result = await getNotificationsUseCase(
      page: _currentPage,
      limit: _limit,
    );

    result.fold((failure) => _currentPage--, (newNotifications) {
      if (newNotifications.isEmpty) {
        emit((state as NotificationLoaded).copyWith(hasReachedMax: true));
      } else {
        final processedItems = _processNewItems(newNotifications);
        _allItems.addAll(processedItems);

        emit(
          NotificationLoaded(
            items: List.from(_allItems),
            hasReachedMax: newNotifications.length < _limit,
            newNotificationIds: _computeNewIds(_allItems),
          ),
        );
      }
    });

    _isFetching = false;
  }

  Future<void> refreshNotifications() async {
    _currentPage = 1;
    _lastHeader = null;
    _isFetching = true;

    final result = await getNotificationsUseCase(
      page: _currentPage,
      limit: _limit,
    );

    result.fold(
      (failure) => emit(NotificationError(_mapFailureToMessage(failure))),
      (newNotifications) {
        _allItems.clear();
        final processedItems = _processNewItems(newNotifications);
        _allItems.addAll(processedItems);

        emit(
          NotificationLoaded(
            items: List.from(_allItems),
            hasReachedMax: newNotifications.length < _limit,
            newNotificationIds: _computeNewIds(_allItems), // badge updates here
          ),
        );
      },
    );

    _isFetching = false;
  }

  Future<void> markAsRead(String notificationId) async {
    final index = _allItems.indexWhere(
      (item) =>
          item is NotificationDataItem &&
          item.notification.id == notificationId,
    );

    if (index != -1) {
      final oldItem = _allItems[index] as NotificationDataItem;
      final oldNotif = oldItem.notification;

      if (!oldNotif.isRead) {
        final updatedNotif = NotificationEntity(
          id: oldNotif.id,
          receiverId: oldNotif.receiverId,
          senderId: oldNotif.senderId,
          senderName: oldNotif.senderName,
          senderAvatar: oldNotif.senderAvatar,
          type: oldNotif.type,
          message: oldNotif.message,
          entityId: oldNotif.entityId,
          postId: oldNotif.postId,
          isRead: true,
          createdAt: oldNotif.createdAt,
        );

        _allItems[index] = NotificationDataItem(updatedNotif);

        if (state is NotificationLoaded) {
          emit(
            (state as NotificationLoaded).copyWith(items: List.from(_allItems)),
          );
        }

        final result = await openNotificationUseCase(notificationId);

        result.fold((failure) {}, (_) {});
      }
    }
  }

  List<NotificationListItem> _processNewItems(
    List<NotificationEntity> newNotifications,
  ) {
    final List<NotificationListItem> newItems = [];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var notification in newNotifications) {
      final date = DateTime(
        notification.createdAt.year,
        notification.createdAt.month,
        notification.createdAt.day,
      );

      String currentHeader;
      if (date == today) {
        currentHeader = 'today';
      } else if (date == yesterday) {
        currentHeader = 'yesterday';
      } else {
        currentHeader = 'earlier';
      }

      if (currentHeader != _lastHeader) {
        newItems.add(NotificationHeaderItem(currentHeader));
        _lastHeader = currentHeader;
      }

      newItems.add(NotificationDataItem(notification));
    }

    return newItems;
  }

  /// Call this from your push-notification handler (FCM onMessage, etc.)
  void onPushNotificationReceived(NotificationEntity newNotification) {
    // If not yet loaded, just let the next fetch handle it
    if (state is! NotificationLoaded) return;

    final loadedState = state as NotificationLoaded;

    // Avoid duplicates
    final alreadyExists = _allItems.any(
      (item) =>
          item is NotificationDataItem &&
          item.notification.id == newNotification.id,
    );
    if (alreadyExists) return;

    // Insert header "today" at the top if needed
    final List<NotificationListItem> updated = [];
    final firstItem = _allItems.isNotEmpty ? _allItems.first : null;
    final firstIsToday =
        firstItem is NotificationHeaderItem && firstItem.title == 'today';

    if (!firstIsToday) {
      updated.add(const NotificationHeaderItem('today'));
    }

    updated.add(NotificationDataItem(newNotification));
    updated.addAll(_allItems);

    _allItems
      ..clear()
      ..addAll(updated);

    emit(
      loadedState.copyWith(
        items: List.from(_allItems),
        newNotificationIds: _computeNewIds(
          _allItems,
        ), 
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) return failure.message;
    if (failure is NetworkFailure) return failure.message;
    if (failure is AuthFailure) return failure.message;
    return 'Unexpected error occurred';
  }
}
