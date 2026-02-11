import 'package:auth/data/models/join_request_model.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auth/common/api_endpoints.dart';
import 'package:auth/common/functions/handle_dio_error.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/models/group_model.dart';
import 'package:auth/data/models/group_member_model.dart';
import 'package:auth/data/models/group_post_model.dart';
import '../../common/api_service.dart';

abstract class GroupRemoteDataSource {
  // Core Group
  Future<GroupModel> createGroup({
    required String name,
    required String description,
    required String coverImage,
    String? privacy,
  });
  Future<GroupModel> updateGroup({
    required String groupId,
    String? name,
    String? description,
    String? coverImage,
    String? privacy,
  });
  Future<void> deleteGroup(String groupId);
  Future<GroupModel> getGroup(String groupId);
  Future<List<GroupModel>> getGroups({int page = 1, String? search});

  // Membership
  Future<String> joinGroup(String groupId);
  Future<void> leaveGroup(String groupId);
  Future<void> cancelJoinRequest(String groupId);
  Future<List<JoinRequestModel>> getJoinRequests({
    required String groupId,
    int page = 1,
  });
  Future<void> acceptJoinRequest({
    required String groupId,
    required String requestId,
  });
  Future<void> declineJoinRequest({
    required String groupId,
    required String requestId,
  });

  // Moderation
  Future<void> promoteMember({
    required String groupId,
    required String userId,
    required String role,
  });
  Future<void> demoteMember({
    required String groupId,
    required String userId,
    required String role,
  });
  Future<void> kickMember({required String groupId, required String userId});
  Future<void> banMember({required String groupId, required String userId});
  Future<void> unbanMember({required String groupId, required String userId});
  Future<List<GroupMemberModel>> getMembers({
    required String groupId,
    int page = 1,
  });
  Future<List<GroupMemberModel>> getAdmins({
    required String groupId,
    int page = 1,
  });
  Future<List<GroupMemberModel>> getModerators({
    required String groupId,
    int page = 1,
  });
  // Posts
  Future<GroupPostModel> createGroupPost({
    required String groupId,
    String? caption,
    List<XFile>? media,
  });
  Future<void> deleteGroupPost({
    required String groupId,
    required String postId,
  });
  Future<GroupPostModel> updateGroupPost({
    required String groupId,
    required String postId,
    required String caption,
  });
  Future<List<GroupPostModel>> getGroupPosts({
    required String groupId,
    int page = 1,
  });
  Future<GroupPostModel> getGroupPostById({
    required String groupId,
    required String postId,
  });
  Future<List<GroupPostModel>> getGroupFeed({int page = 1});
}

class GroupRemoteDataSourceImpl implements GroupRemoteDataSource {
  final ApiService api;
  final SharedPreferences prefs;
  final ErrorHandler errorHandler;

  GroupRemoteDataSourceImpl({
    required this.api,
    required this.prefs,
    required this.errorHandler,
  });

  Options _getAuthOptions() {
    final token = prefs.getString('auth_token');
    if (token == null) throw AuthException('No auth token found');
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  // --- 1. Create Group ---
  @override
  Future<GroupModel> createGroup({
    required String name,
    required String description,
    required String coverImage,
    String? privacy,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'description': description,
        'privacy': privacy ?? 'private',
        'logo': await MultipartFile.fromFile(
          coverImage,
          filename: coverImage.split('/').last,
        ),
      });

      final response = await api.post(
        ApiEndpoints.groups,
        data: formData,
        options: _getAuthOptions(),
      );
      return GroupModel.fromJson(response['data']['group']);
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  // --- 2. Update Group ---
  @override
  Future<GroupModel> updateGroup({
    required String groupId,
    String? name,
    String? description,
    String? coverImage,
    String? privacy,
  }) async {
    try {
      final Map<String, dynamic> dataMap = {};
      if (name != null) dataMap['name'] = name;
      if (description != null) dataMap['description'] = description;
      if (privacy != null) dataMap['privacy'] = privacy;

      final formData = FormData.fromMap(dataMap);
      if (coverImage != null) {
        formData.files.add(
          MapEntry(
            'logo',
            await MultipartFile.fromFile(
              coverImage,
              filename: coverImage.split('/').last,
            ),
          ),
        );
      }

      final response = await api.patch(
        "${ApiEndpoints.groups}/$groupId",
        data: formData,
        options: _getAuthOptions(),
      );
      return GroupModel.fromJson(response['data']['group']);
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  // --- 3. Get Groups (Pagination & Search) ---
  @override
  Future<List<GroupModel>> getGroups({int page = 1, String? search}) async {
    try {
      final query = search != null
          ? "?page=$page&keyword=$search"
          : "?page=$page";
      final response = await api.get(
        "${ApiEndpoints.groups}$query",
        options: _getAuthOptions(),
      );
      final list = response['data']['data'] as List;
      return list.map((e) => GroupModel.fromJson(e)).toList();
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  // --- 4. Create Group Post (Handles multiple 'media' files) ---
  @override
  Future<GroupPostModel> createGroupPost({
    required String groupId,
    String? caption,
    List<XFile>? media,
  }) async {
    try {
      final formData = FormData.fromMap({'caption': caption ?? ''});
      if (media != null) {
        for (var file in media) {
          formData.files.add(
            MapEntry(
              'media',
              await MultipartFile.fromFile(file.path, filename: file.name),
            ),
          );
        }
      }
      final response = await api.post(
        "${ApiEndpoints.groups}/$groupId/posts",
        data: formData,
        options: _getAuthOptions(),
      );
      return GroupPostModel.fromJson(response['data']['post']);
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  // --- 5. Membership Actions ---
  @override
  Future<String> joinGroup(String groupId) async {
    try {
      final response = await api.post(
        "${ApiEndpoints.groups}/$groupId/join",
        options: _getAuthOptions(),
      );
      print(response['message']);
      return response['message'];
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  // --- Helper for simplified Delete/Post requests ---
  @override
  Future<void> deleteGroup(String groupId) async =>
      await _simpleDelete("${ApiEndpoints.groups}/$groupId");

  @override
  Future<GroupModel> getGroup(String groupId) async {
    final response = await api.get(
      "${ApiEndpoints.groups}/$groupId",
      options: _getAuthOptions(),
    );
    return GroupModel.fromJson(response['data']['group']);
  }

  @override
  Future<void> leaveGroup(String groupId) async =>
      await _simpleDelete("${ApiEndpoints.groups}/$groupId/leave");

  @override
  Future<void> cancelJoinRequest(String groupId) async =>
      await _simpleDelete("${ApiEndpoints.groups}/$groupId/requests/cancel");

  @override
  Future<List<JoinRequestModel>> getJoinRequests({
    required String groupId,
    int page = 1,
  }) async {
    final response = await api.get(
      "${ApiEndpoints.groups}/$groupId/requests?page=$page",
      options: _getAuthOptions(),
    );
    final list = response['data']['data'] as List;
    return list.map((item) => JoinRequestModel.fromJson(item)).toList();
  }

  @override
  Future<void> acceptJoinRequest({
    required String groupId,
    required String requestId,
  }) async => await api.post(
    "${ApiEndpoints.groups}/$groupId/requests/$requestId/accept",
    options: _getAuthOptions(),
  );

  @override
  Future<void> declineJoinRequest({
    required String groupId,
    required String requestId,
  }) async => await api.post(
    "${ApiEndpoints.groups}/$groupId/requests/$requestId/decline",
    options: _getAuthOptions(),
  );

  // --- Moderation ---
  @override
  Future<void> promoteMember({
    required String groupId,
    required String userId,
    required String role,
  }) async => await _memberRoleAction(groupId, userId, role, "promote");

  @override
  Future<void> demoteMember({
    required String groupId,
    required String userId,
    required String role,
  }) async => await _memberRoleAction(groupId, userId, role, "demote");

  @override
  Future<void> kickMember({
    required String groupId,
    required String userId,
  }) async => await _memberAction(groupId, userId, "kick");

  @override
  Future<void> banMember({
    required String groupId,
    required String userId,
  }) async => await _memberAction(groupId, userId, "ban");

  @override
  Future<void> unbanMember({
    required String groupId,
    required String userId,
  }) async => await _memberAction(groupId, userId, "unban");

  @override
  Future<List<GroupMemberModel>> getMembers({
    required String groupId,
    int page = 1,
  }) async {
    final response = await api.get(
      "${ApiEndpoints.groups}/$groupId/members?page=$page",
      options: _getAuthOptions(),
    );
    final list = response['data']['data'] as List;
    return list.map((e) => GroupMemberModel.fromJson(e)).toList();
  }

  @override
  Future<List<GroupMemberModel>> getModerators({
    required String groupId,
    int page = 1,
  }) async {
    final response = await api.get(
      "${ApiEndpoints.groups}/$groupId/moderators?page=$page",
      options: _getAuthOptions(),
    );
    final list = response['data']['data'] as List;
    return list.map((e) => GroupMemberModel.fromJson(e)).toList();
  }

  @override
  Future<List<GroupMemberModel>> getAdmins({
    required String groupId,
    int page = 1,
  }) async {
    final response = await api.get(
      "${ApiEndpoints.groups}/$groupId/admins?page=$page",
      options: _getAuthOptions(),
    );
    final list = response['data']['data'] as List;
    return list.map((e) => GroupMemberModel.fromJson(e)).toList();
  }

  // --- Posts ---
  @override
  Future<void> deleteGroupPost({
    required String groupId,
    required String postId,
  }) async => await api.delete(
    "${ApiEndpoints.groups}/$groupId/posts/$postId",
    options: _getAuthOptions(),
  );

  @override
  Future<GroupPostModel> updateGroupPost({
    required String groupId,
    required String postId,
    required String caption,
  }) async {
    final response = await api.patch(
      "${ApiEndpoints.groups}/$groupId/posts/$postId",
      data: {'caption': caption},
      options: _getAuthOptions(),
    );
    return GroupPostModel.fromJson(response['data']['post']);
  }

  @override
  Future<List<GroupPostModel>> getGroupPosts({
    required String groupId,
    int page = 1,
  }) async {
    final response = await api.get(
      "${ApiEndpoints.groups}/$groupId/posts?page=$page",
      options: _getAuthOptions(),
    );
    final list = response['data']['data'] as List;
    return list.map((e) => GroupPostModel.fromJson(e)).toList();
  }

  @override
  Future<GroupPostModel> getGroupPostById({
    required String groupId,
    required String postId,
  }) async {
    final response = await api.get(
      "${ApiEndpoints.groups}/$groupId/posts/$postId",
      options: _getAuthOptions(),
    );
    return GroupPostModel.fromJson(response['data']['post']);
  }

  @override
  Future<List<GroupPostModel>> getGroupFeed({int page = 1}) async {
    final response = await api.get(
      "${ApiEndpoints.groups}/feed?page=$page",
      options: _getAuthOptions(),
    );
    final list = response['data']['posts'] as List;
    return list.map((e) => GroupPostModel.fromJson(e)).toList();
  }

  // --- Private Helpers to reduce code repetition ---
  Future<void> _simpleDelete(String path) async {
    try {
      await api.delete(path, options: _getAuthOptions());
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  Future<void> _memberAction(
    String groupId,
    String userId,
    String action,
  ) async {
    try {
      await api.post(
        "${ApiEndpoints.groups}/$groupId/$action",
        data: {'targetUserId': userId},
        options: _getAuthOptions(),
      );
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  Future<void> _memberRoleAction(
    String groupId,
    String userId,
    String role,
    String action,
  ) async {
    try {
      await api.post(
        "${ApiEndpoints.groups}/$groupId/$action",
        data: {'targetUserId': userId, 'newRole': role},
        options: _getAuthOptions(),
      );
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }
}
