import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<Either<Failure, void>> call({
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
    final trimmedEmail = email.trim();

    if (trimmedEmail.contains('@')) {
      if (!emailRegex.hasMatch(trimmedEmail)) {
        return const Left(
          ValidationFailure('Please enter a valid email address'),
        );
      }
    } else {
      if (trimmedEmail.length < 3) {
        return const Left(
          ValidationFailure('Username must be at least 3 characters'),
        );
      }
    }

    return await repository.signIn(
      email: trimmedEmail,
      password: password,
    );
  }
}
