import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/usecases/notfication/delete_fcm_token_usecase.dart';
import 'package:auth/domain/usecases/notfication/register_fcm_token_usecase.dart';
import 'package:auth/domain/usecases/sign_in/google_sign_in_and_rigester_usecases.dart';
import 'package:auth/domain/usecases/sign_in/signin_usecase.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/sign_in_state.dart';
import 'package:auth/services/fcm_helper.dart';
import 'package:auth/services/social_auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SignInCubit extends Cubit<SignInState> {
  final SignInUseCase _signInUseCase;
  final GoogleSignInAndRegisterUseCase _googleSignInUseCase;
  final SocialAuthService socialAuthService = SocialAuthService();

  final RegisterFcmTokenUseCase _registerFcmTokenUseCase;
  final DeleteFcmTokenUseCase _deleteFcmTokenUseCase;

  SignInCubit({
    required SignInUseCase signInUseCase,
    required GoogleSignInAndRegisterUseCase googleSignInUseCase,
    required RegisterFcmTokenUseCase registerFcmTokenUseCase,
    required DeleteFcmTokenUseCase deleteFcmTokenUseCase,
  }) : _signInUseCase = signInUseCase,
       _googleSignInUseCase = googleSignInUseCase,
       _registerFcmTokenUseCase = registerFcmTokenUseCase,
       _deleteFcmTokenUseCase = deleteFcmTokenUseCase,
       super(const SignInInitial());
  Future<void> _syncFcmToken() async {
    try {
      String? token = await FcmHelper.getDeviceToken();

      if (token != null) {
        await _registerFcmTokenUseCase.call(token);
        //print("✅ FCM Token registered after login/google sync");
      }
    } catch (e) {
     // print("⚠️ FCM Sync Error (Non-critical): $e");
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(const SignInLoading());

    final result = await _signInUseCase(email: email, password: password);

    result.fold((failure) => emit(_mapFailureToState(failure)), (_) async {
      await _syncFcmToken();
      emit(const SignInSuccess());
    });
  }

  Future<void> signInAndRegisterWithGoogle() async {
    emit(const SignInLoading());
    try {
      final idToken = await socialAuthService.getGoogleIdToken();
      if (idToken == null) {
        emit(const SignInFailure(message: "cancelled", errorType: "auth"));
        return;
      }

      final result = await _googleSignInUseCase(idToken: idToken);
      result.fold((failure) => emit(_mapFailureToState(failure)), (_) async {
        await _syncFcmToken();
        emit(const SignInSuccess());
      });
    } catch (e) {
      emit(const SignInFailure(message: "failed", errorType: "auth"));
    }
  }

  SignInFailure _mapFailureToState(Failure failure) {
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

  Future<void> logout() async {
    try {
      String? fcmToken = await FcmHelper.getDeviceToken();
      if (fcmToken != null) {
        await _deleteFcmTokenUseCase.call(fcmToken);
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await socialAuthService.signOut();
      emit(const SignInInitial());
    } catch (e) {
      emit(
        const SignInFailure(
          message: "Logout failed. Please try again.",
          errorType: "server",
        ),
      );
    }
  }

  void resetState() => emit(const SignInInitial());

  bool get isLoading => state is SignInLoading;
  bool get isSuccess => state is SignInSuccess;
  bool get isFailure => state is SignInFailure;
  bool get isInitial => state is SignInInitial;
}
