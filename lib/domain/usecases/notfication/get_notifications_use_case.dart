import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/notification.dart';
import 'package:auth/domain/repositories/notification_repo.dart';
import 'package:dartz/dartz.dart';

class GetNotificationsUseCase {
  final NotificationRepo repo;

  GetNotificationsUseCase(this.repo);

  Future<Either<Failure, List<NotificationEntity>>> call({
    required int page,
    int limit = 20,
  }) {
    return repo.getNotifications(page: page, limit: limit);
  }
}
