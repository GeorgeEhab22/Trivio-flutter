import 'package:auth/common/api_endpoints.dart';
import 'package:auth/common/functions/handle_dio_error.dart';
import 'package:auth/data/core/error/exceptions.dart';
import '../../common/api_service.dart';
import '../models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  /// 1️⃣ Get detailed info about the currently authenticated user
  Future<UserProfileModel> getMyProfile();
  Future<UserProfileModel> updateInterests(Map<String, dynamic> data);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiService api;
  final ErrorHandler errorHandler;

  ProfileRemoteDataSourceImpl({required this.api, required this.errorHandler});

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

  @override
  Future<UserProfileModel> updateInterests(Map<String, dynamic> data) async {
    try {
      final response = await api.patch(ApiEndpoints.updateProfile, data: data);
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
}
