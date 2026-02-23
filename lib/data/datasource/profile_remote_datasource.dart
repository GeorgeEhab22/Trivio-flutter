import 'package:auth/common/api_endpoints.dart';
import 'package:auth/common/functions/handle_dio_error.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/api_service.dart';
import '../models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  /// 1️⃣ Get detailed info about the currently authenticated user
  Future<UserProfileModel> getMyProfile();

  // interests
  Future<UserProfileModel> updateInterests(Map<String, dynamic> data);
  Future<List<String>> getFavTeams();
  Future<List<String>> getFavPlayers();
  Future<void> removeFavTeams(List<String> teams);
  Future<void> removeFavPlayers(List<String> players);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiService api;
  final SharedPreferences prefs;
  final ErrorHandler errorHandler;

  ProfileRemoteDataSourceImpl({
    required this.api,
    required this.prefs,
    required this.errorHandler,
  });

  Options _getAuthOptions() {
    final token = prefs.getString('auth_token');
    if (token == null) throw AuthException('No auth token found');
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  @override
  Future<UserProfileModel> getMyProfile() async {
    try {
      final response = await api.get(ApiEndpoints.myProfile);

      if (response["status"] == "success") {
        final userData = response['data']?['user'];
        if (userData != null) {
          return UserProfileModel.fromJson(userData);
        } else {
          throw ServerException('User data not found in response');
        }
      } else {
        throw ServerException('Failed to fetch user profile');
      }
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

// interests
  @override
  Future<UserProfileModel> updateInterests(Map<String, dynamic> data) async {
    try {
      final response = await api.patch(
        ApiEndpoints.updateProfile,
        data: data,
        options: _getAuthOptions(),
      );
      print(response);
      if (response["status"] == "success") {
        return UserProfileModel.fromJson(response['data']['user']);
      } else {
        throw ServerException('Failed to update interests');
      }
    } catch (e) {
      print(e);
      errorHandler.handleDioError(e);
      rethrow;
    }
  }
  @override
  Future<List<String>> getFavTeams() async {
    final response = await api.get(ApiEndpoints.favTeams, options: _getAuthOptions());
    return List<String>.from(response['data']['teams']);
  }

  @override
  Future<List<String>> getFavPlayers() async {
    final response = await api.get(ApiEndpoints.favPlayers, options: _getAuthOptions());
    return List<String>.from(response['data']['players']);
  }

  @override
  Future<void> removeFavTeams(List<String> teams) async {
    await api.delete(
      ApiEndpoints.removeFavTeams,
      data: {'teams': teams},
      options: _getAuthOptions(),
    );
  }

  @override
  Future<void> removeFavPlayers(List<String> players) async {
    await api.delete(
      ApiEndpoints.removeFavPlayers,
      data: {'players': players},
      options: _getAuthOptions(),
    );
  }
}
