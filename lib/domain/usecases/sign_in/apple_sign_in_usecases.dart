import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/user.dart';
import 'package:auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

class AppleSignInUseCase {
  final AuthRepository repository;
  AppleSignInUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String identityToken,
    required String authorizationCode,
  }) {
    return repository.signInWithApple(
      identityToken: identityToken,
      authorizationCode: authorizationCode,
    );
  }
}
