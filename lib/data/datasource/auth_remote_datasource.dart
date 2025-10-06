import 'dart:io';
import 'package:auth/common/api_endpoints.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../../common/api_service.dart';

abstract class AuthRemoteDataSource {
  Future<void> signIn({required String email, required String password});
  Future<UserModel> signUp({required String email, required String username, required String password});
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Future<void> forgotPassword({required String email});

  Future<UserModel> signInWithGoogle( {required String idToken});
  Future<UserModel> signInWithApple( {required String identityToken, required String authorizationCode});
  Future<UserModel> registerWithGoogle( {required String idToken});
  Future<UserModel> registerWithApple( {required String identityToken, required String authorizationCode});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService api;
  final SharedPreferences prefs;

  AuthRemoteDataSourceImpl({
    required this.api,
    required this.prefs,
  });

  Future<String?> _getToken() async => prefs.getString('auth_token');
  Future<void> _storeToken(String token) async => prefs.setString('auth_token', token);
  Future<void> _clearToken() async => prefs.remove('auth_token');

  @override
  @override
Future<void> signIn({required String email, required String password}) async {
  try {
    final response = await api.post(ApiEndpoints.login, data: {
      'email': email,
      'password': password,
    });
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
  Future<UserModel> signUp({required String email, required String username, required String password}) async {
    try {
      final response = await api.post(ApiEndpoints.signup, data: {
        'email': email,
        'username': username,
        'password': password,
      });

      final user = UserModel.fromJson(response['user']);
      if (response['token'] != null) {
        await _storeToken(response['token']);
      }
      return user;
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (_) {
      throw AuthException('Failed to sign up');
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
  Future<UserModel> signInWithGoogle({required String idToken}) async {
    try {
      final response = await api.post(ApiEndpoints.googleSignIn, data: {
        "idToken": idToken,
      });

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
      final response = await api.post(ApiEndpoints.appleSignIn, data: {
        "identityToken": identityToken,
        "authorizationCode": authorizationCode,
      });

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
      final response = await api.post(ApiEndpoints.googleRegister, data: {
        "idToken": idToken,
      });

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
      final response = await api.post(ApiEndpoints.appleRegister, data: {
        "identityToken": identityToken,
        "authorizationCode": authorizationCode,
      });

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

