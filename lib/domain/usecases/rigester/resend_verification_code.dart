import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

class ResendVerificationCode {
  final AuthRepository repository;

  ResendVerificationCode(this.repository);

  Future<Either<Failure, void>> call(String email, String username) {
    return repository.resendVerificationCode( email: email, username: username);
  }
}
