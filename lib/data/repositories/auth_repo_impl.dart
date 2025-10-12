import 'package:auth/core/errors/failure.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/datasource/auth_remote_datasource.dart';
import 'package:auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> signIn({
    required String email,
    required String password,
    required bool isEmail,
  }) async {
    try {
      await remoteDataSource.signIn(email: email, password: password, isEmail: isEmail);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, User>> signUp({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.signUp(
        email: email,
        username: username,
        password: password,
      );
      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to sign out'));
    }
  }

  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      if (userModel != null) {
        return Right(userModel.toEntity());
      } else {
        return const Right(null);
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to get current user'));
    }
  }


  @override
  Future<Either<Failure, User>> signInWithGoogle({
    required String idToken,
  }) async {
    try {
      final userModel = await remoteDataSource.signInWithGoogle(
        idToken: idToken,
      );
      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Google sign-in failed'));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithApple({
    required String identityToken,
    required String authorizationCode,
  }) async {
    try {
      final userModel = await remoteDataSource.signInWithApple(
        identityToken: identityToken,
        authorizationCode: authorizationCode,
      );
      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Apple sign-in failed'));
    }
  }

  @override
  Future<Either<Failure, User>> registerWithGoogle({
    required String idToken,
  }) async {
    try {
      final userModel = await remoteDataSource.registerWithGoogle(
        idToken: idToken,
      );
      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Google registration failed'));
    }
  }

  @override
  Future<Either<Failure, User>> registerWithApple({
    required String identityToken,
    required String authorizationCode,
  }) async {
    try {
      final userModel = await remoteDataSource.registerWithApple(
        identityToken: identityToken,
        authorizationCode: authorizationCode,
      );
      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Apple registration failed'));
    }
  }

  @override
  Future<Either<Failure, void>> resendVerificationCode({required String email, required String username}) {
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> verifyCode({
    required String email,
    required String code,
  }) async {
    try {
      await remoteDataSource.verifyCode(email: email, code: code);
      return const Right('Verification code sent');
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to verify code'));
    }
  }
  @override
  Future<Either<Failure, User>> verifyOTP({
    required String otp,
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.verifyOTP(
        otp: otp,
        email: email,
        password: password,
      );
      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('OTP verification failed'));
    }
  }
  @override
  Future<Either<Failure, String>> sendPasswordResetOtp({required String email}) async {
    try {
      await remoteDataSource.sendPasswordResetOtp(email: email);
      return const Right('Password reset OTP sent');
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to send password reset OTP'));
    }
  }
}
