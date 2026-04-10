import 'package:auth/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/notification.dart';

abstract class NotificationRepo {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    required int page,
    required int limit,
  });

  Future<Either<Failure, void>> openNotification(String notificationId);

  Future<Either<Failure, void>> registerFcmToken(String token);
  Future<Either<Failure, void>> deleteFcmToken(String token);
}
