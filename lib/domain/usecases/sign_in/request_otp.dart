import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

class SendPasswordResetOtp {
  final AuthRepository repository;

  SendPasswordResetOtp(this.repository);
  Future<Either<Failure, String>> call({required String email}) {
    return repository.sendPasswordResetOtp(email: email);
  }
}