import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/notification_repo.dart';
import 'package:dartz/dartz.dart';

class OpenNotificationUseCase {
  final NotificationRepo repo;

  OpenNotificationUseCase(this.repo);

  Future<Either<Failure, void>> call(String notificationId) {
    return repo.openNotification(notificationId);
  }
}
