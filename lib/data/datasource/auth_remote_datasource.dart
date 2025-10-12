import 'dart:io';
import 'package:auth/common/api_endpoints.dart';
import 'package:auth/common/functions/handle_dio_error.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../../common/api_service.dart';

abstract class AuthRemoteDataSource {
  Future<void> signIn({
    required String email,
    required String password,
    required bool isEmail,
  });
  Future<UserModel> signUp({
    required String email,
    required String username,
    required String password,
  });

  Future<void> verifyCode({required String code, required String email});
  Future<void> resendVerificationCode({
    required String email,
    required String username,
  });
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Future<void> sendPasswordResetOtp({required String email});
  Future<UserModel> verifyOTP({
    required String otp,
    required String email,
    required String password,
  });
  Future<UserModel> signInWithGoogle({required String idToken});
  Future<UserModel> signInWithApple({
    required String identityToken,
    required String authorizationCode,
  });
  Future<UserModel> registerWithGoogle({required String idToken});
  Future<UserModel> registerWithApple({
    required String identityToken,
    required String authorizationCode,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService api;
  final SharedPreferences prefs;
  final ErrorHandler errorHandler;

  AuthRemoteDataSourceImpl({
    required this.api,
    required this.prefs,
    required this.errorHandler,
  });

  Future<String?> _getToken() async => prefs.getString('auth_token');
  Future<void> _storeToken(String token) async =>
      prefs.setString('auth_token', token);
  Future<void> _clearToken() async => prefs.remove('auth_token');

  @override
  Future<void> signIn({
    required String email,
    required String password,
    required bool isEmail,
  }) async {
    try {
      final response = isEmail
          ? await api.post(
              ApiEndpoints.login,
              data: {'email': email, 'password': password},
            )
          : await api.post(
              ApiEndpoints.login,
              data: {'username': email, 'password': password},
            );
      final token = response['data']?[0];

      if (token != null) {
        await _storeToken(token);
      } else {
        throw AuthException('Token not found in response');
      }
    } catch (e) {
      errorHandler.handleDioError(e);
    }
  }

  @override
  Future<UserModel> verifyOTP({
    required String otp,
    required String email,
    required String password,
  }) async {
    try {
      final response = await api.patch(
        ApiEndpoints.forgetPassword,
        data: {'otp': otp, 'email': email, 'password': password},
      );

      if (response["status"] == "success") {
        final data = response['data'];

        if (data != null && data.isNotEmpty) {
          final user = UserModel.fromJson(data[0]);
          if (response['token'] != null) {
            await _storeToken(response['token']);
          }
          return user;
        } else {
          throw ServerException('Invalid response data');
        }
      } else {
        throw AuthException('OTP verification failed');
      }
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final response = await api.post(
        ApiEndpoints.signup,
        data: {'email': email, 'username': username, 'password': password},
      );

      if (response["status"] == "success") {
        final data = response['data'];

        if (data != null && data.isNotEmpty) {
          return UserModel.fromJson(data[0]);
        } else {
          throw ServerException('Invalid response data');
        }
      } else {
        throw ServerException('Sign up failed');
      }
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<void> verifyCode({required String code, required String email}) async {
    try {
      final response = await api.patch(
        ApiEndpoints.verifyEmail,
        data: {'code': code, 'email': email},
      );
      if (response['status'] != 'success') {
        throw AuthException('Invalid verification code');
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      throw AuthException('Failed to verify code');
    }
  }

  @override
  Future<void> resendVerificationCode({
    required String email,
    required String username,
  }) async {
    try {
      final response = await api.patch(
        ApiEndpoints.resendVerificationCode,
        data: {'email': email, 'username': username},
      );
      if (response['status'] != 'success') {
        throw AuthException('Failed to resend verification code');
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      throw AuthException('Failed to resend verification code');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      final token = await _getToken();
      if (token != null) {
        await api.post(ApiEndpoints.signout, data: {});
      }
      await _clearToken();
    } catch (_) {
      await _clearToken();
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await api.get(ApiEndpoints.me);
      return UserModel.fromJson(response['user']);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> sendPasswordResetOtp({required String email}) async {
    try {
      final response = await api.patch(
        ApiEndpoints.requestOTP,
        data: {'email': email},
      );
      if (response['status'] != 'success') {
        throw AuthException('Failed to send OTP');
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (_) {
      throw AuthException('Failed to send reset password email');
    }
  }

  @override
  Future<UserModel> signInWithGoogle({required String idToken}) async {
    try {
      final response = await api.post(
        ApiEndpoints.googleSignIn,
        data: {"idToken": idToken},
      );

      final user = UserModel.fromJson(response['user']);
      if (response['token'] != null) {
        await _storeToken(response['token']);
      }
      return user;
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (_) {
      throw AuthException('Failed to sign in with Google');
    }
  }

  @override
  Future<UserModel> signInWithApple({
    required String identityToken,
    required String authorizationCode,
  }) async {
    try {
      final response = await api.post(
        ApiEndpoints.appleSignIn,
        data: {
          "identityToken": identityToken,
          "authorizationCode": authorizationCode,
        },
      );

      final user = UserModel.fromJson(response['user']);
      if (response['token'] != null) {
        await _storeToken(response['token']);
      }
      return user;
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (_) {
      throw AuthException('Failed to sign in with Apple');
    }
  }

  @override
  Future<UserModel> registerWithGoogle({required String idToken}) async {
    try {
      final response = await api.post(
        ApiEndpoints.googleRegister,
        data: {"idToken": idToken},
      );

      final user = UserModel.fromJson(response['user']);
      if (response['token'] != null) {
        await _storeToken(response['token']);
      }
      return user;
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (_) {
      throw AuthException('Failed to register with Google');
    }
  }

  @override
  Future<UserModel> registerWithApple({
    required String identityToken,
    required String authorizationCode,
  }) async {
    try {
      final response = await api.post(
        ApiEndpoints.appleRegister,
        data: {
          "identityToken": identityToken,
          "authorizationCode": authorizationCode,
        },
      );

      final user = UserModel.fromJson(response['user']);
      if (response['token'] != null) {
        await _storeToken(response['token']);
      }
      return user;
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (_) {
      throw AuthException('Failed to register with Apple');
    }
  }
}
