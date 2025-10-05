import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/user.dart';
import 'package:auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

class AppleRegisterUseCase {
  final AuthRepository repository;

  AppleRegisterUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String identityToken,
    required String authorizationCode,
  }) {
    return repository.registerWithApple(
      identityToken: identityToken,
      authorizationCode: authorizationCode,
    );
  }
}
