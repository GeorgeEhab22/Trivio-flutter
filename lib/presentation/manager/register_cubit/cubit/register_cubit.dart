// ignore_for_file: type_literal_in_constant_pattern

import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/user.dart';
import 'package:auth/domain/usecases/rigester/apple_register_usecase.dart';
import 'package:auth/domain/usecases/rigester/google_register_usecase.dart';
import 'package:auth/domain/usecases/rigester/register_usecase.dart';
import 'package:auth/presentation/manager/register_cubit/cubit/register_state.dart';
import 'package:auth/services/social_auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase _registerUseCase;
  final GoogleRegisterUseCase _googleRegisterUseCase;
  final AppleRegisterUseCase _appleRegisterUseCase;
  final SocialAuthService socialAuthService = SocialAuthService();

  RegisterCubit({
    required RegisterUseCase registerUseCase,
    required GoogleRegisterUseCase googleRegisterUseCase,
    required AppleRegisterUseCase appleRegisterUseCase,
  })  : _registerUseCase = registerUseCase,
        _googleRegisterUseCase = googleRegisterUseCase,
        _appleRegisterUseCase = appleRegisterUseCase,
        super(const RegisterInitial());

  /// Email + Password registration
  Future<void> register({
    required String email,
    required String password,
    required String username,
  }) async {
    emit(const RegisterLoading());

    final result = await _registerUseCase(email: email, password: password, username: username);

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (user) => emit(RegisterSuccess(user: user)),
    );
  }

  /// Google registration
  Future<void> registerWithGoogle() async {
    emit(const RegisterLoading());
    try {
      final idToken = await socialAuthService.getGoogleIdToken();
      if (idToken == null) {
        emit(const RegisterFailure(
          message: "Google sign-up cancelled",
          errorType: "auth",
        ));
        return;
      }

      final result = await _googleRegisterUseCase(idToken: idToken);
      result.fold(
        (failure) => emit(_mapFailureToState(failure)),
        (user) => emit(RegisterSuccess(user: user)),
      );
    } catch (e) {
      emit(const RegisterFailure(
        message: "Google sign-up failed",
        errorType: "auth",
      ));
    }
  }

  /// Apple registration
  Future<void> registerWithApple() async {
    emit(const RegisterLoading());
    try {
      final creds = await socialAuthService.getAppleCredentials();
      if (creds == null) {
        emit(const RegisterFailure(
          message: "Apple sign-up cancelled",
          errorType: "auth",
        ));
        return;
      }

      final result = await _appleRegisterUseCase(
        identityToken: creds['identityToken']!,
        authorizationCode: creds['authorizationCode']!,
      );

      result.fold(
        (failure) => emit(_mapFailureToState(failure)),
        (user) => emit(RegisterSuccess(user: user)),
      );
    } catch (e) {
      emit(const RegisterFailure(
        message: "Apple sign-up failed",
        errorType: "auth",
      ));
    }
  }

  /// Map failures
  RegisterFailure _mapFailureToState(Failure failure) {
    switch (failure.runtimeType) {
      case ValidationFailure:
        return RegisterFailure(message: failure.message, errorType: 'validation');
      case NetworkFailure:
        return RegisterFailure(message: failure.message, errorType: 'network');
      case AuthFailure:
        return RegisterFailure(message: failure.message, errorType: 'auth');
      default:
        return RegisterFailure(message: failure.message, errorType: 'server');
    }
  }

  void resetState() => emit(const RegisterInitial());

  /// Helpers
  bool get isLoading => state is RegisterLoading;
  bool get isSuccess => state is RegisterSuccess;
  bool get isFailure => state is RegisterFailure;
  bool get isInitial => state is RegisterInitial;

  User? get currentUser =>
      state is RegisterSuccess ? (state as RegisterSuccess).user : null;

  String? get errorMessage =>
      state is RegisterFailure ? (state as RegisterFailure).message : null;
}
