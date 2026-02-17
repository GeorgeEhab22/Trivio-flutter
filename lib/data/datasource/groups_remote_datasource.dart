import 'package:auth/data/models/join_request_model.dart';
import 'package:auth/data/models/post_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auth/common/api_endpoints.dart';
import 'package:auth/common/functions/handle_dio_error.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/models/group_model.dart';
import 'package:auth/data/models/group_member_model.dart';
import '../../common/api_service.dart';

abstract class GroupRemoteDataSource {
  // Core Group
  Future<GroupModel> createGroup({
    required String name,
    String? description,
    XFile? coverImage,
  });
  Future<GroupModel> updateGroup({
    required String groupId,
    String? name,
    String? description,
    XFile? coverImage,
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
  Future<List<GroupMemberModel>> getBannedMembers({
    required String groupId,
    int page = 1,
  });
  // Posts
  Future<PostModel> createGroupPost({
    required String groupId,
    String? caption,
    List<XFile>? media,
    required String type,
  });
  Future<void> deleteGroupPost({
    required String groupId,
    required String postId,
  });
  Future<PostModel> updateGroupPost({
    required String groupId,
    required String postId,
    required String caption,
  });
  Future<List<PostModel>> getGroupPosts({
    required String groupId,
    int page = 1,
  });
  Future<PostModel> getGroupPostById({
    required String groupId,
    required String postId,
  });
  Future<List<PostModel>> getGroupFeed({int page = 1});
  Future<List<GroupModel>> getMyGroups({int page = 1, String? search});
  Future<List<GroupModel>> getJoinedGroups({int page = 1, String? search});
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
    String? description,
    XFile? coverImage,
  }) async {
    try {
      final Map<String, dynamic> body = {'name': name, 'privacy': 'private'};
      if (description != null && description.trim().isNotEmpty) {
        body['description'] = description;
      }
      if (coverImage != null) {
        if (kIsWeb) {
          final bytes = await coverImage.readAsBytes();
          body['logo'] = MultipartFile.fromBytes(
            bytes,
            filename: coverImage.name,
          );
        } else {
          body['logo'] = await MultipartFile.fromFile(
            coverImage.path,
            filename: coverImage.name,
          );
        }
      }

      final formData = FormData.fromMap(body);

      final response = await api.post(
        ApiEndpoints.groups,
        data: formData,
        options: _getAuthOptions(),
      );
      // print(response);
      return GroupModel.fromJson(response['data']['group']);
    } catch (e) {
      // print(e);
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
    XFile? coverImage,
    String? privacy,
  }) async {
    try {
      final Map<String, dynamic> dataMap = {};
      if (name != null) dataMap['name'] = name;
      if (description != null) dataMap['description'] = description;
      if (privacy != null) dataMap['privacy'] = privacy;

      final formData = FormData.fromMap(dataMap);
      if (coverImage != null) {
        if (kIsWeb) {
          final bytes = await coverImage.readAsBytes();
          formData.files.add(
            MapEntry(
              'logo',
              MultipartFile.fromBytes(bytes, filename: coverImage.name),
            ),
          );
        } else {
          formData.files.add(
            MapEntry(
              'logo',
              await MultipartFile.fromFile(
                coverImage.path,
                filename: coverImage.name,
              ),
            ),
          );
        }
      }

      final response = await api.patch(
        "${ApiEndpoints.groups}/$groupId",
        data: formData,
        options: _getAuthOptions(),
      );
      // print(response);
      return GroupModel.fromJson(response['data']['group']);
    } catch (e) {
      // print(e);
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

 

  // --- 5. Membership Actions ---
  @override
  Future<String> joinGroup(String groupId) async {
    try {
      final response = await api.post(
        "${ApiEndpoints.groups}/$groupId/join",
        options: _getAuthOptions(),
      );
      // print(response['message']);
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
    try {
      final response = await api.get(
        "${ApiEndpoints.groups}/$groupId",
        options: _getAuthOptions(),
      );
      return GroupModel.fromJson(response['data']['group']);
    } catch (e) {
      // print(e);
      errorHandler.handleDioError(e);
      rethrow;
    }
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

  @override
  Future<List<GroupMemberModel>> getBannedMembers({
    required String groupId,
    int page = 1,
  }) async {
    final response = await api.get(
      "${ApiEndpoints.groups}/$groupId/banned?page=$page",
      options: _getAuthOptions(),
    );
    final list = response['data']['data'] as List;
    return list.map((e) => GroupMemberModel.fromJson(e)).toList();
  }

  // --- Posts ---

 @override
  Future<PostModel> createGroupPost({
    required String groupId,
    String? caption,
    List<XFile>? media,
    required String type,
  }) async {
    try {
      final formData = FormData.fromMap({'caption': caption ?? '', 'type': type});
      if (media != null) {
        for (var file in media) {
          if (kIsWeb) {
            final bytes = await file.readAsBytes();
            formData.files.add(MapEntry(
              'media',
              MultipartFile.fromBytes(bytes, filename: file.name),
            ));
          } else {
            formData.files.add(MapEntry(
              'media',
              await MultipartFile.fromFile(file.path, filename: file.name),
            ));
          }
        }
      }
      final response = await api.post(
        "${ApiEndpoints.groups}/$groupId/posts",
        data: formData,
        options: _getAuthOptions(),
      );
      // print(response);
      return PostModel.fromJson(response['data']['post']);
    } catch (e) {
      // print(e);
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<void> deleteGroupPost({
    required String groupId,
    required String postId,
  }) async {
    try {
      await api.delete(
        "${ApiEndpoints.groups}/$groupId/posts/$postId",
        options: _getAuthOptions(),
      );
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<PostModel> updateGroupPost({
    required String groupId,
    required String postId,
    required String caption,
  }) async {
    try {
      final response = await api.patch(
        "${ApiEndpoints.groups}/$groupId/posts/$postId",
        data: {'caption': caption},
        options: _getAuthOptions(),
      );
      return PostModel.fromJson(response['data']['post']);
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<List<PostModel>> getGroupPosts({
    required String groupId,
    int page = 1,
  }) async {
    try {
      final response = await api.get(
        "${ApiEndpoints.groups}/$groupId/posts?page=$page",
        options: _getAuthOptions(),
      );
      final list = response['data']['data'] as List;
      return list.map((e) => PostModel.fromJson(e)).toList();
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<PostModel> getGroupPostById({
    required String groupId,
    required String postId,
  }) async {
    try {
      final response = await api.get(
        "${ApiEndpoints.groups}/$groupId/posts/$postId",
        options: _getAuthOptions(),
      );
      return PostModel.fromJson(response['data']['post']);
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<List<PostModel>> getGroupFeed({int page = 1}) async {
    try {
      final response = await api.get(
        "${ApiEndpoints.groups}/feed?page=$page",
        options: _getAuthOptions(),
      );
      final list = response['data']['posts'] as List;
      return list.map((e) => PostModel.fromJson(e)).toList();
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
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

  // --- Get My Groups ---
  @override
  Future<List<GroupModel>> getMyGroups({int page = 1, String? search}) async {
    try {
      final query = search != null
          ? "?page=$page&keyword=$search"
          : "?page=$page";
      final response = await api.get(
        "${ApiEndpoints.myGroups}$query",
        options: _getAuthOptions(),
      );
      final list = response['data']['groups'] as List;
      return list.map((e) => GroupModel.fromJson(e)).toList();
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  // --- Get Joined Groups ---
  @override
  Future<List<GroupModel>> getJoinedGroups({
    int page = 1,
    String? search,
  }) async {
    try {
      final query = search != null
          ? "?page=$page&keyword=$search"
          : "?page=$page";
      final response = await api.get(
        "${ApiEndpoints.joinedGroups}$query",
        options: _getAuthOptions(),
      );
      final list = response['data']['groups'] as List;
      return list.map((e) => GroupModel.fromJson(e)).toList();
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }
}
