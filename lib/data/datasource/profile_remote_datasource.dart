import 'dart:io';

import 'package:auth/common/api_endpoints.dart';
import 'package:auth/common/api_service.dart';
import 'package:auth/common/functions/handle_dio_error.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ProfileRemoteDataSource {
  Future<List<UserModel>> getFollowRequests();
  Future<UserModel> acceptFollowRequest({required String requestId});
  Future<void> declineFollowRequest({required String requestId});
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
  Future<List<UserModel>> getFollowRequests() async {
    try {
      final response = await api.get(ApiEndpoints.followRequests);

      if (response['status'] == 'success') {
        final List requests = response['data']['requests'];

        return requests
            .map((e) => UserModel.fromJson(e['follwerId']))
            .toList();
      } else {
        throw ServerException('Failed to fetch follow requests');
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<UserModel> acceptFollowRequest({
    required String requestId,
  }) async {
    try {
      final response = await api.patch(
        '${ApiEndpoints.acceptFollowRequest}/$requestId/accept',
      );

      if (response['status'] == 'success') {
        final follow = response['data']['follow'];

        /// follower user is inside `follwerId`
        return UserModel.fromJson(follow['follwerId']);
      } else {
        throw ServerException('Failed to accept follow request');
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<void> declineFollowRequest({
    required String requestId,
  }) async {
    try {
      await api.patch(
        '${ApiEndpoints.declineFollowRequest}/$requestId/decline',
      );
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }
}
