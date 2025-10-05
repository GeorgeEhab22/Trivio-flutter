import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/user.dart';
import 'package:auth/domain/usecases/sign_in/apple_sign_in_usecases.dart';
import 'package:auth/domain/usecases/sign_in/google_sign_in_usecases.dart';
import 'package:auth/domain/usecases/sign_in/signin_usecase.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/cubit/sign_in_state.dart';
import 'package:auth/services/social_auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInCubit extends Cubit<SignInState> {
  final SignInUseCase _signInUseCase;
  final GoogleSignInUseCase _googleSignInUseCase;
  final AppleSignInUseCase _appleSignInUseCase;
  final SocialAuthService socialAuthService = SocialAuthService();
  SignInCubit({
    required SignInUseCase signInUseCase,
    required GoogleSignInUseCase googleSignInUseCase,
    required AppleSignInUseCase appleSignInUseCase,
  }) : _signInUseCase = signInUseCase,
       _googleSignInUseCase = googleSignInUseCase,
       _appleSignInUseCase = appleSignInUseCase,
       super(const SignInInitial());
  Future<void> signIn({required String email, required String password}) async {
    emit(const SignInLoading());

    final result = await _signInUseCase(email: email, password: password);

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (user) => emit(SignInSuccess(user: user)),
    );
  }

 Future<void> signInWithGoogle() async {
  emit(const SignInLoading());
  try {
    final idToken = await socialAuthService.getGoogleIdToken();
    if (idToken == null) {
      emit(const SignInFailure(message: "Google sign-in cancelled", errorType: "auth"));
      return;
    }
    final result = await _googleSignInUseCase(idToken: idToken);
    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (user) => emit(SignInSuccess(user: user)),
    );
  } catch (e) {
    emit(const SignInFailure(message: "Google sign-in failed", errorType: "auth"));
  }
}

Future<void> signInWithApple() async {
  emit(const SignInLoading());
  try {
    final creds = await socialAuthService.getAppleCredentials();
    if (creds == null) {
      emit(const SignInFailure(message: "Apple sign-in cancelled", errorType: "auth"));
      return;
    }
    final result = await _appleSignInUseCase(
      identityToken: creds['identityToken']!,
      authorizationCode: creds['authorizationCode']!,
    );
    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (user) => emit(SignInSuccess(user: user)),
    );
  } catch (e) {
    emit(const SignInFailure(message: "Apple sign-in failed", errorType: "auth"));
  }
}
  SignInFailure _mapFailureToState(Failure failure) {
    switch (failure.runtimeType) {
      // ignore: type_literal_in_constant_pattern
      case ValidationFailure:
        return SignInFailure(message: failure.message, errorType: 'validation');
      // ignore: type_literal_in_constant_pattern
      case NetworkFailure:
        return SignInFailure(message: failure.message, errorType: 'network');
      // ignore: type_literal_in_constant_pattern
      case AuthFailure:
        return SignInFailure(message: failure.message, errorType: 'auth');
      default:
        return SignInFailure(message: failure.message, errorType: 'server');
    }
  }

  void resetState() => emit(const SignInInitial());

  bool get isLoading => state is SignInLoading;
  bool get isSuccess => state is SignInSuccess;
  bool get isFailure => state is SignInFailure;
  bool get isInitial => state is SignInInitial;

  User? get currentUser => state is SignInSuccess ? (state as SignInSuccess).user : null;
  String? get errorMessage => state is SignInFailure ? (state as SignInFailure).message : null;
}
