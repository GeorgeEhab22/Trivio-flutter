import 'package:auth/common/api_endpoints.dart';
import 'package:auth/common/functions/handle_dio_error.dart';
import 'package:auth/data/core/error/exceptions.dart';
import '../../common/api_service.dart';
import '../models/follow_model.dart';
import '../models/follow_request_model.dart';

abstract class FollowRemoteDataSource {
  Future<FollowModel> followUser({required String userId});
  Future<void> unfollowUser({required String userId});
  Future<List<FollowRequestModel>> getMyFollowRequests();
  Future<FollowModel> acceptFollowRequest({required String requestId});
  Future<void> declineFollowRequest({required String requestId});
  Future<List<FollowModel>> getUserFollowers({required String userId});
  Future<List<FollowModel>> getUserFollowing({required String userId});
  Future<List<FollowModel>> getMyFollowers({int page = 1, int limit = 10});
  Future<List<FollowModel>> getMyFollowing({int page = 1, int limit = 10});
}

class FollowRemoteDataSourceImpl implements FollowRemoteDataSource {
  final ApiService api;
  final ErrorHandler errorHandler;

  FollowRemoteDataSourceImpl({
    required this.api,
    required this.errorHandler,
  });

//   // Simple private helper to print the real error before the handler masks it
//   void _logError(String method, dynamic e) {
//     print('--- [ERROR] FollowRemoteDataSource.$method ---');
//     print('Exception: $e');
//     if (e is DioException) {
//       print('Response Data: ${e.response?.data}');
//       print('Status Code: ${e.response?.statusCode}');
//     }
//     print('---------------------------------------------');
//   }

//   @override
//   Future<List<FollowModel>> getMyFollowers({int page = 1, int limit = 10}) async {
//     try {
//       return _getDummyFollowers();

//       final response = await api.get(
//         ApiEndpoints.myFollowers,
//         query: {'page': page, 'limit': limit},
//       );

//       if (response["status"] == "success") {
//         final List followers = response['data']?['followers'] ?? [];
//         return followers.map((e) => FollowModel.fromJson(e)).toList();
//       } else {
//         throw ServerException('Failed to get my followers');
//       }
//     } catch (e) {
//       _logError('getMyFollowers', e);
//       errorHandler.handleDioError(e);
//       rethrow;
//     }
//   }

// // --- DUMMY DATA GENERATORS ---


//   List<FollowModel> _getDummyFollowers() {
//     return List.generate(5, (index) => FollowModel(
//       id: 'follow_id_$index',
//       status: 'accepted',
//       // We pass a Map to the factory to create a UserReference with a preview
//       user: UserReference.fromJson({
//         '_id': 'me_123',
//         'name': 'Shahd',
//         'avatar': '',
//       }),
//       follower: UserReference.fromJson({
//         '_id': 'user_$index',
//         'name': 'Follower $index',
//         'avatar': 'https://i.pravatar.cc/150?u=$index',
//       }),
//       createdAt: DateTime.now(),
//       updatedAt: DateTime.now(),
//     ));
//   }

//   List<FollowModel> _getDummyFollowing() {
//     return List.generate(3, (index) => FollowModel(
//       id: 'following_id_$index',
//       status: 'accepted',
//       user: UserReference.fromJson({
//         '_id': 'me_123',
//         'name': 'Shahd',
//         'avatar': '',
//       }),
//       follower: UserReference.fromJson({
//         '_id': 'target_$index',
//         'name': 'Following $index',
//         'avatar': 'https://i.pravatar.cc/150?u=target_$index',
//       }),
//     ));
//   }
//   List<FollowRequestModel> _getDummyRequests() {
//     return [
//       FollowRequestModel(
//         id: 'req_abc_1',
//         userId: 'me_123',
//         followerId: 'pending_u1',
//         status: 'pending',
//         // Uses UserProfilePreview as per your FollowRequestModel
//         follower: UserProfilePreview(
//           id: 'pending_u1',
//           name: 'Omar Khaled',
//           avatarUrl: 'https://i.pravatar.cc/150?u=omar',
//         ),
//       ),
//       FollowRequestModel(
//         id: 'req_abc_2',
//         userId: 'me_123',
//         followerId: 'pending_u2',
//         status: 'pending',
//         follower: UserProfilePreview(
//           id: 'pending_u2',
//           name: 'Mariam Ali',
//           avatarUrl: 'https://i.pravatar.cc/150?u=mariam',
//         ),
//       ),
//     ];
//   }

//   @override
//   Future<List<FollowModel>> getMyFollowing({int page = 1, int limit = 10}) async {
//     try {
//       return _getDummyFollowing();

//       final response = await api.get(
//         ApiEndpoints.myFollowing,
//         query: {'page': page, 'limit': limit},
//       );

//       if (response["status"] == "success") {
//         final List following = response['data']?['following'] ?? [];
//         return following.map((e) => FollowModel.fromJson(e)).toList();
//       } else {
//         throw ServerException('Failed to get my following');
//       }
//     } catch (e) {
//       _logError('getMyFollowing', e);
//       errorHandler.handleDioError(e);
//       rethrow;
//     }
//   }

//   @override
//   Future<List<FollowRequestModel>> getMyFollowRequests() async {
//     try {
//       return _getDummyRequests();

//       final response = await api.get(ApiEndpoints.myFollowRequests);

//       if (response["status"] == "success") {
//         final List requests = response['data']?['requests'] ?? [];
//         return requests.map((e) => FollowRequestModel.fromJson(e)).toList();
//       } else {
//         throw ServerException('Failed to get follow requests');
//       }
//     } catch (e) {
//       _logError('getMyFollowRequests', e);
//       errorHandler.handleDioError(e);
//       rethrow;
//     }
//   }

  /// 1️⃣ POST - Follow User
  @override
  Future<FollowModel> followUser({required String userId}) async {
    try {
      final response = await api.post(
        ApiEndpoints.followUser(userId),
      );

      if (response["status"] == "success") {
        final follow = response['data']?['follow'];
        return FollowModel.fromJson(follow);
      } else {
        throw ServerException('Failed to follow user');
      }
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  /// 2️⃣ DELETE - Unfollow User
  @override
  Future<void> unfollowUser({required String userId}) async {
    try {
      final response = await api.delete(
        ApiEndpoints.followUser(userId),
      );
      if(response.statusCode != 204){
        throw ServerException('Failed to unfollow user');
      }
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  /// 3️⃣ GET - My Follow Requests
  @override
  Future<List<FollowRequestModel>> getMyFollowRequests() async {
    try {
      final response = await api.get(
        ApiEndpoints.myFollowRequests,
      );

      if (response["status"] == "success") {
        final List requests = response['data']?['requests'] ?? [];
        return requests
            .map((e) => FollowRequestModel.fromJson(e))
            .toList();
      } else {
        throw ServerException('Failed to get follow requests');
      }
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  /// 4️⃣ PATCH - Accept Follow Request
  @override
  Future<FollowModel> acceptFollowRequest({
    required String requestId,
  }) async {
    try {
      final response = await api.patch(
        ApiEndpoints.acceptFollowRequest(requestId),
      );

      if (response["status"] == "success") {
        final follow = response['data']?['follow'];
        return FollowModel.fromJson(follow);
      } else {
        throw ServerException('Failed to accept follow request');
      }
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  /// 5️⃣ PATCH - Decline Follow Request
  @override
  Future<void> declineFollowRequest({
    required String requestId,
  }) async {
    try {
      await api.patch(
        ApiEndpoints.declineFollowRequest(requestId),
      );
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  /// 6️⃣ GET - User Followers
  @override
  Future<List<FollowModel>> getUserFollowers({
    required String userId,
  }) async {
    try {
      final response = await api.get(
        ApiEndpoints.getUserFollowers(userId),
      );

      if (response["status"] == "success") {
        final List followers = response['data']?['followers'] ?? [];
        return followers
            .map((e) => FollowModel.fromJson(e))
            .toList();
      } else {
        throw ServerException('Failed to get followers');
      }
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  /// 7️⃣ GET - User Following
  @override
  Future<List<FollowModel>> getUserFollowing({
    required String userId,
  }) async {
    try {
      final response = await api.get(
        ApiEndpoints.getUserFollowing(userId),
      );

      if (response["status"] == "success") {
        final List following = response['data']?['following'] ?? [];
        return following
            .map((e) => FollowModel.fromJson(e))
            .toList();
      } else {
        throw ServerException('Failed to get following list');
      }
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  // / 8️⃣ GET - My Followers (Paginated)
  @override
  Future<List<FollowModel>> getMyFollowers({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await api.get(
        ApiEndpoints.myFollowers,
        query: {
          'page': page,
          'limit': limit,
        },
      );

      if (response["status"] == "success") {
        final List followers = response['data']?['followers'] ?? [];
        return followers
            .map((e) => FollowModel.fromJson(e))
            .toList();
      } else {
        throw ServerException('Failed to get my followers');
      }
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  // / 9️⃣ GET - My Following (Paginated)
  @override
  Future<List<FollowModel>> getMyFollowing({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await api.get(
        ApiEndpoints.myFollowing,
        query: {
          'page': page,
          'limit': limit,
        },
      );

      if (response["status"] == "success") {
        final List following = response['data']?['following'] ?? [];
        return following
            .map((e) => FollowModel.fromJson(e))
            .toList();
      } else {
        throw ServerException('Failed to get my following');
      }
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }
  
}
  