import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> signIn({
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> signInAndRegisterWithGoogle({
    required String idToken,
  });
  Future<Either<Failure, User>> register({
    required String email,
    required String username,
    required String password,
  });
  Future<Either<Failure, String>> verifyCode({
    required String email,
    required String code,
  });
  Future<Either<Failure, void>> resendVerificationCode({required String email});
}
