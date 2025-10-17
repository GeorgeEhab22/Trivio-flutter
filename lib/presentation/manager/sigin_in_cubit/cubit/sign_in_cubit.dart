import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/usecases/sign_in/google_sign_in_and_rigester_usecases.dart';
import 'package:auth/domain/usecases/sign_in/signin_usecase.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/cubit/sign_in_state.dart';
import 'package:auth/services/social_auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInCubit extends Cubit<SignInState> {
  final SignInUseCase _signInUseCase;
  final GoogleSignInAndRegisterUseCase _googleSignInUseCase;
  final SocialAuthService socialAuthService = SocialAuthService();

  SignInCubit({
    required SignInUseCase signInUseCase,
    required GoogleSignInAndRegisterUseCase googleSignInUseCase,
  }) : _signInUseCase = signInUseCase,
       _googleSignInUseCase = googleSignInUseCase,
       super(const SignInInitial());

  Future<void> signIn({required String email, required String password}) async {
    emit(const SignInLoading());

    final result = await _signInUseCase(email: email, password: password);

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (_) => emit(const SignInSuccess()),
    );
  }

  Future<void> signInAndRegisterWithGoogle() async {
    emit(const SignInLoading());
    try {
      final idToken = await socialAuthService.getGoogleIdToken();
      if (idToken == null) {
        emit(
          const SignInFailure(
            message: "Google sign-in cancelled",
            errorType: "auth",
          ),
        );
        return;
      }

      final result = await _googleSignInUseCase(idToken: idToken);
      result.fold(
        (failure) => emit(_mapFailureToState(failure)),
        (_) => emit(SignInSuccess()),
      );
      emit(const SignInSuccess());
    } catch (e) {
      emit(
        const SignInFailure(
          message: "Google sign-in failed",
          errorType: "auth",
        ),
      );
    }
  }

  SignInFailure _mapFailureToState(Failure failure) {
    print("Failure type: ${failure.runtimeType}, message: ${failure.message}");

    switch (failure.runtimeType) {
      case const (ValidationFailure):
        return SignInFailure(message: failure.message, errorType: 'validation');
      case const (NetworkFailure):
        return SignInFailure(message: failure.message, errorType: 'network');
      case const (AuthFailure):
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
}
