import 'dart:io';
import 'package:auth/common/api_endpoints.dart';
import 'package:auth/common/functions/handle_dio_error.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/domain/entities/user_profile_preview.dart';
import 'package:dio/dio.dart';
import '../../common/api_service.dart';
import '../models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getMyProfile();
  Future<UserProfileModel> updateProfile({
    String? username,
    String? bio,
    File? avatarFile,
  });
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<List<UserProfilePreview>> getSuggestions();
  Future<List<String>> getLikedPostsIds();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiService api;
  final ErrorHandler errorHandler;

  ProfileRemoteDataSourceImpl({required this.api, required this.errorHandler});

  @override
  Future<List<UserProfilePreview>> getSuggestions() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      UserProfilePreview(
        id: 'sug_1',
        name: 'Dr. Ahmed Elsayed',
        avatarUrl: 'https://i.pravatar.cc/150?u=a',
      ),
      UserProfilePreview(
        id: 'sug_2',
        name: 'Sara Kamel',
        avatarUrl: 'https://i.pravatar.cc/150?u=s',
      ),
      UserProfilePreview(
        id: 'sug_3',
        name: 'Layla Mahmoud',
        avatarUrl: 'https://i.pravatar.cc/150?u=l',
      ),
    ];
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

  @override
  Future<UserProfileModel> updateProfile({
    String? username,
    String? bio,
    File? avatarFile,
  }) async {
    try {
      // Using Map for form-data
      final Map<String, dynamic> data = {
        if (username != null) "username": username,
        if (bio != null) "bio": bio,
        if (avatarFile != null)
          "avatar": await MultipartFile.fromFile(
            avatarFile.path,
            //filename: avatarFile.path.split('/').last,
          ),
      };

      final response = await api.patch(ApiEndpoints.updateProfile, data: data);
      return UserProfileModel.fromJson(response['data']['user']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await api.patch(
        ApiEndpoints.changePassword,
        data: {"currentPassword": currentPassword, "newPassword": newPassword},
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  // @override
  // Future<List<UserProfilePreview>> getSuggestions() async {
  //   try {
  //     final response = await api.get(ApiEndpoints.suggestions);
  //     final List list = response['data']['suggestions'];
  //     return list.map((item) => UserProfilePreview(
  //       id: item['_id'],
  //       name: item['username'],
  //       avatarUrl: item['avatar']
  //     )).toList();
  //   } catch (e) { throw _handleError(e); }
  // }

  @override
  Future<List<String>> getLikedPostsIds() async {
    try {
      final response = await api.get(ApiEndpoints.likedPostsIds);
      return List<String>.from(response['data']['likedPosts']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic e) {
    errorHandler.handleDioError(e);
    return ServerException('Operation failed');
  }
}
