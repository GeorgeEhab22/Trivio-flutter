import 'package:auth/core/errors/failure.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/datasource/notifications_remote_datasource.dart';
import 'package:auth/domain/entities/notification.dart';
import 'package:auth/domain/repositories/notification_repo.dart';
import 'package:dartz/dartz.dart';

class NotificationRepoImpl implements NotificationRepo {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    required int page,
    required int limit,
  }) async {
    try {
      final models = await remoteDataSource.getNotifications(
        page: page,
        limit: limit,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to get notifications'));
    }
  }

  @override
  Future<Either<Failure, void>> openNotification(String notificationId) async {
    try {
      await remoteDataSource.openNotification(notificationId);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to open notification'));
    }
  }

  @override
  Future<Either<Failure, void>> registerFcmToken(String token) async {
    try {
      await remoteDataSource.registerFcmToken(token);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFcmToken(String token) async {
    try {
      await remoteDataSource.deleteFcmToken(token);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
