import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

class VerifyCode {
  final AuthRepository repository;

  VerifyCode(this.repository);

  Future<Either<Failure, String?>> call({
    required String email,
    required String code,
  }) {
    return repository.verifyCode(email: email, code: code);
  }
}
