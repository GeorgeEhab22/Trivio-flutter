import 'package:auth/core/errors/failure.dart';
import 'package:auth/core/validator.dart';
import 'package:auth/domain/entities/user.dart';
import 'package:auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

class VerifyOTP {
  final AuthRepository repository;
 
  VerifyOTP(this.repository);

  Future<Either<Failure, User>> call({
    required String otp,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (otp.trim().isEmpty) {
      return const Left(ValidationFailure('OTP is required'));
    }
    if (email.trim().isEmpty) {
      return const Left(ValidationFailure('Email is required'));
    }

    if (password.isEmpty) {
      return const Left(ValidationFailure('Password is required'));
    }
    if (confirmPassword.isEmpty) {
      return const Left(ValidationFailure('Confirm Password is required'));
    }

    if (!Validator.isValidPassword(password)) {
      return const Left(ValidationFailure('Please enter a valid password'));
    }
    if (password != confirmPassword) {
      return const Left(ValidationFailure('Passwords do not match'));
    }

    if (password.length < 8) {
      return const Left(
        ValidationFailure('Password must be at least 8 characters'),
      );
    }

    return await repository.verifyOTP(
      otp: otp,
      email: email,
      password: password,
    );
  }
}
