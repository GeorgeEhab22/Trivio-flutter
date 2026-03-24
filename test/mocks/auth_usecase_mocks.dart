import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/user.dart';
import 'package:auth/domain/usecases/register/register_usecase.dart';
import 'package:auth/domain/usecases/sign_in/google_sign_in_and_rigester_usecases.dart';
import 'package:auth/domain/usecases/sign_in/request_otp.dart';
import 'package:auth/domain/usecases/sign_in/signin_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';

class MockSignInUseCase extends Mock implements SignInUseCase {}

class MockGoogleSignInAndRegisterUseCase extends Mock
    implements GoogleSignInAndRegisterUseCase {}

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockSendPasswordResetOtp extends Mock implements SendPasswordResetOtp {}

void stubSignInFailure(
  MockSignInUseCase useCase, {
  Failure failure = const AuthFailure('invalid_credentials'),
}) {
  when(
    () => useCase(
      email: any(named: 'email'),
      password: any(named: 'password'),
    ),
  ).thenAnswer((_) async => Left(failure));
}

void stubRegisterFailure(
  MockRegisterUseCase useCase, {
  Failure failure = const AuthFailure('email_taken'),
}) {
  when(
    () => useCase(
      email: any(named: 'email'),
      username: any(named: 'username'),
      password: any(named: 'password'),
      confirmPassword: any(named: 'confirmPassword'),
    ),
  ).thenAnswer((_) async => Left(failure));
}

void stubGoogleSignInSuccess(MockGoogleSignInAndRegisterUseCase useCase) {
  when(() => useCase(idToken: any(named: 'idToken'))).thenAnswer(
    (_) async =>
        const Right(User(email: 'google@test.com', username: 'google_user')),
  );
}

void stubRequestOtpSuccess(MockSendPasswordResetOtp useCase) {
  when(
    () => useCase(email: any(named: 'email')),
  ).thenAnswer((_) async => const Right('ok'));
}

void stubRequestOtpFailure(
  MockSendPasswordResetOtp useCase, {
  Failure failure = const NetworkFailure('No internet connection'),
}) {
  when(
    () => useCase(email: any(named: 'email')),
  ).thenAnswer((_) async => Left(failure));
}
