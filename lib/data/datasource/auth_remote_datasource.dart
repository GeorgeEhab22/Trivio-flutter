import 'dart:io';
import 'package:auth/common/api_endpoints.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../../common/api_service.dart';

abstract class AuthRemoteDataSource {
  Future<void> signIn({required String email, required String password});
  Future<UserModel> register({
    required String email,
    required String username,
    required String password,
  });
  Future<void> verifyCode({required String code, required String email});
  Future<void> resendVerificationCode({required String email});
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Future<void> forgotPassword({required String email});

  Future<UserModel> signInAndRegisterWithGoogle({required String idToken});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService api;
  final SharedPreferences prefs;

  AuthRemoteDataSourceImpl({required this.api, required this.prefs});

  Future<String?> _getToken() async => prefs.getString('auth_token');
  Future<void> _storeToken(String token) async =>
      prefs.setString('auth_token', token);
  Future<void> _clearToken() async => prefs.remove('auth_token');

  @override
  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      final response = await api.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      final token = response['data']?[0];
      if (token != null) {
        await _storeToken(token);
      } else {
        throw AuthException('Token not found in response');
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      throw AuthException('Failed to sign in');
    }
  }

  @override
  Future<UserModel> register({
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
    } on DioException catch (e) {
      final errorData = e.response?.data;
      String errorMessage = 'An error occurred';

      if (errorData is Map && errorData['message'] != null) {
        errorMessage = errorData['message'];
      }
      throw ServerException(errorMessage);
    } on SocketException {
      throw NetworkException('No internet connection');
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
  Future<void> resendVerificationCode({required String email}) async {
    try {
      final response = await api.post(
        ApiEndpoints.resendVerificationCode,
        data: {'email': email},
      );
      if (response['status'] != 'success') {
        throw AuthException(response['message'] ?? 'Failed to resend code');
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
  Future<void> forgotPassword({required String email}) async {
    try {
      await api.post(ApiEndpoints.forgotPassword, data: {'email': email});
    } catch (_) {
      throw AuthException('Failed to send reset password email');
    }
  }

  @override
  Future<UserModel> signInAndRegisterWithGoogle({
    required String idToken,
  }) async {
    try {
      final response = await api.post(
        ApiEndpoints.googleSignIn,
        data: {"idToken": idToken},
      );

      final jtwToken = response['data'] != null && response['data'].isNotEmpty
          ? response['data'][0]
          : null;

      if (jtwToken != null) {
        await _storeToken(jtwToken);
      }

      return UserModel.empty();
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (_) {
      throw AuthException('Failed to sign in with Google');
    }
  }
}
