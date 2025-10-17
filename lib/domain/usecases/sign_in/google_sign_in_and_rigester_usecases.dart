import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/user.dart';
import 'package:auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

class GoogleSignInAndRegisterUseCase {
  final AuthRepository repository;

  GoogleSignInAndRegisterUseCase(this.repository);

  Future<Either<Failure, User>> call({required String idToken}) async {
    return await repository.signInAndRegisterWithGoogle(idToken: idToken);
  }
}
