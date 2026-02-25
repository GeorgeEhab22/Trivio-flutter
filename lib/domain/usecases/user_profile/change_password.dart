import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/user_profile_repo.dart';
import 'package:dartz/dartz.dart';

class ChangePassword {
  final UserProfileRepo repository;
  ChangePassword(this.repository);

  Future<Either<Failure, Unit>> call(String currentPassword, String newPassword) async {
    return await repository.changePassword(currentPassword, newPassword);
  }
}
