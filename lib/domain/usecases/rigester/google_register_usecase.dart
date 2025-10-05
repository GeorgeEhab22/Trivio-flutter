import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/user.dart';
import 'package:auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

class GoogleRegisterUseCase {
  final AuthRepository repository;

  GoogleRegisterUseCase(this.repository);

  Future<Either<Failure, User>> call({required String idToken}) async {
    return await repository.registerWithGoogle(idToken: idToken);
  }
}
