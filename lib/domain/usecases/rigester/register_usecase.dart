import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/user.dart';
import 'package:auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String email,
    required String username,
    required String password,
  }) async {
    if (email.trim().isEmpty) {
      return const Left(ValidationFailure('Email is required'));
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email.trim())) {
      return const Left(ValidationFailure('Please enter a valid email address'));
    }

    if (username.trim().isEmpty) {
      return const Left(ValidationFailure('Username is required'));
    }

    if (username.trim().length < 3) {
      return const Left(
        ValidationFailure('Username must be at least 3 characters'),
      );
    }

    if (password.isEmpty) {
      return const Left(ValidationFailure('Password is required'));
    }

    if (password.length < 8) {
      return const Left(
        ValidationFailure('Password must be at least 8 characters'),
      );
    }
    return await repository.signUp(
      email: email.trim(),
      username: username.trim(),
      password: password,
    );
  }
}

