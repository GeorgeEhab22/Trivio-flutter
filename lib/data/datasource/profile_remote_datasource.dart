import 'package:auth/common/api_endpoints.dart';
import 'package:auth/common/functions/handle_dio_error.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/models/post_model.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/user_profile_preview.dart';
import 'package:dio/dio.dart';
import '../../common/api_service.dart';
import '../models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getMyProfile();
  Future<UserProfileModel> getUserProfileById(String userId);
  Future<UserProfileModel> updateProfile({
    String? username,
    String? bio,
    XFile? avatarFile,
  });
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<List<UserProfilePreview>> getSuggestions();
  Future<List<Post>> getLikedPostsIds();
  Future<List<Post>> getLikedPosts();
  Future<List<Post>> getMyPosts();
  Future<List<String>> getSavedPosts();
  Future<void> savePost(String postId);
  Future<void> unsavePost(String postId);
  Future<List<Post>> getUserPostsById(String userId);
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
  Future<UserProfileModel> getUserProfileById(String userId) async {
    try {
      final response = await api.get(ApiEndpoints.getProfileById(userId));

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
    XFile? avatarFile,
  }) async {
    try {
      final Map<String, dynamic> data = {};

      if (username != null && username.isNotEmpty) data["username"] = username;
      if (bio != null && bio.trim().isNotEmpty) {
        data["bio"] = bio;
      }

      if (avatarFile != null) {
        if (kIsWeb) {
          final bytes = await avatarFile.readAsBytes();
          data["avatar"] = MultipartFile.fromBytes(
            bytes,
            filename: 'profile_image.jpg',
          );
        } else {
          data["avatar"] = await MultipartFile.fromFile(
            avatarFile.path,
            filename: avatarFile.path.split('/').last,
          );
        }
      }
      final response = await api.patch(
        ApiEndpoints.updateProfile,
        data: FormData.fromMap(data),
      );
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

  @override
  Future<List<UserProfilePreview>> getSuggestions() async {
    try {
      final response = await api.get(ApiEndpoints.suggestions);
      final List list = response['data']['suggestions'];
      return list
          .map(
            (item) => UserProfilePreview(
              id: item['_id'],
              name: item['username'],
              avatarUrl: item['avatar'],
            ),
          )
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<Post>> getLikedPostsIds() async {
    try {
      final response = await api.get(ApiEndpoints.likedPostsIds);
      return List<Post>.from(response['data']['likedPosts']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic e) {
    errorHandler.handleDioError(e);
    return ServerException(e.message ?? 'An unknown error occurred');
  }

  @override
  Future<List<PostModel>> getMyPosts() async {
    try {
      final response = await api.get(ApiEndpoints.getUserPosts);

      if (response['data'] == null || response['data']['posts'] == null) {
        return [];
      }
      final List postsJson = response['data']['posts'];
      return postsJson.map((json) => PostModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Server Error');
    } catch (e) {
      throw ServerException('Mapping Error: $e');
    }
  }

  @override
  Future<List<PostModel>> getLikedPosts() async {
    try {
      final responseIds = await api.get(ApiEndpoints.likedPostsIds);

      final List<dynamic> rawIds = responseIds['data']['likedPosts'] ?? [];

      if (rawIds.isEmpty) return [];

      final List<String> postIds = rawIds.map((item) {
        return item is Map ? item['_id'].toString() : item.toString();
      }).toList();

      final response = await api.post(
        ApiEndpoints.likedPosts,
        data: {'postIds': postIds},
      );

      final List postsJson = response['data']['posts'] ?? [];
      return postsJson.map((json) => PostModel.fromJson(json)).toList();
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<List<String>> getSavedPosts() async {
    try {
      final response = await api.get(ApiEndpoints.getSavedPosts);

      final dynamic data = response['data'];
      if (data == null || data['savedPosts'] == null) return [];

      final List rawList = data['savedPosts'];

      return rawList
          .where((item) => item != null)
          .map((item) {
            if (item is Map) return item['_id']?.toString() ?? '';
            return item.toString();
          })
          .where((id) => id.isNotEmpty)
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> savePost(String postId) async {
    try {
      await api.post(
        ApiEndpoints.savePost(postId),
        data: {'postId': postId},
        options: Options(contentType: Headers.jsonContentType),
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> unsavePost(String postId) async {
    try {
      await api.delete(
        ApiEndpoints.unsavePost(postId),
        data: {'postId': postId},
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<Post>> getUserPostsById(String userId) async {
    try {
      final response = await api.get(ApiEndpoints.getProfilePosts(userId));

      final dynamic postsWrapper = response['data']['posts'];

      if (postsWrapper is Map && postsWrapper.containsKey('posts')) {
        final List postsList = postsWrapper['posts'];
        return postsList.map((json) => PostModel.fromJson(json)).toList();
      } else if (postsWrapper is List) {
        return postsWrapper.map((json) => PostModel.fromJson(json)).toList();
      }

      return [];
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Server Error');
    } catch (e) {
      throw ServerException('Mapping Error: $e');
    }
  }
}
