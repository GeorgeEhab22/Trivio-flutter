import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';
import '../../entities/user.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty) {
      return const Left(ValidationFailure('Email is required'));
    }

    if (password.isEmpty) {
      return const Left(ValidationFailure('Password is required'));
    }

    if (password.length < 6) {
      return const Left(
        ValidationFailure('Password must be at least 6 characters'),
      );
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (email.contains('@')) {
      if (!emailRegex.hasMatch(email.trim())) {
        return Left(ValidationFailure('Please enter a valid email address'));
      }
    } else {
      if (email.trim().length < 3) {
        return Left(
          ValidationFailure('Username must be at least 3 characters'),
        );
      }
    }

    return await repository.signIn(email: email.trim(), password: password);
  }
}
