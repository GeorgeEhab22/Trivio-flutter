import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/notification_repo.dart';
import 'package:dartz/dartz.dart';

class RegisterFcmTokenUseCase {
  final NotificationRepo repo;
  RegisterFcmTokenUseCase(this.repo);

  Future<Either<Failure, void>> call(String token) {
    return repo.registerFcmToken(token);
  }
}
