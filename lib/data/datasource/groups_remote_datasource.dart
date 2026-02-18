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
  //1- create group
  Future<GroupModel> createGroup({
    required String name,
    String? description,
    XFile? coverImage,
  });
  //2- delete group
  Future<void> deleteGroup(String groupId);

  //3- update group
  Future<GroupModel> updateGroup({
    required String groupId,
    String? name,
    String? description,
    XFile? coverImage,
    String? privacy,
  });
  //4- get group
  Future<GroupModel> getGroup(String groupId);
  //5- get groups
  Future<List<GroupModel>> getGroups({int page = 1, String? search});

  //6- join group
  Future<String> joinGroup(String groupId);
  // 7- leave group
  Future<void> leaveGroup(String groupId);
  // 8- cancel join request
  Future<void> cancelJoinRequest(String groupId);
  // 9- get join requests
  Future<List<JoinRequestModel>> getJoinRequests({
    required String groupId,
    int page = 1,
  });
  // 10- accept join request
  Future<void> acceptJoinRequest({
    required String groupId,
    required String requestId,
  });
  // 11- decline join request
  Future<void> declineJoinRequest({
    required String groupId,
    required String requestId,
  });
  // 12- change member role
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
  // 13- kick member
  Future<void> kickMember({required String groupId, required String userId});
  // 14- ban member
  Future<void> banMember({required String groupId, required String userId});
  // 15- unban member
  Future<void> unbanMember({required String groupId, required String userId});
  // 16- get members
  Future<List<GroupMemberModel>> getMembers({
    required String groupId,
    int page = 1,
  });
  // 17- get admins
  Future<List<GroupMemberModel>> getAdmins({
    required String groupId,
    int page = 1,
  });
  // 18- get moderators
  Future<List<GroupMemberModel>> getModerators({
    required String groupId,
    int page = 1,
  });
  // 19- get banned members
  Future<List<GroupMemberModel>> getBannedMembers({
    required String groupId,
    int page = 1,
  });
  // 20-create group post
  Future<PostModel> createGroupPost({
    required String groupId,
    String? caption,
    List<XFile>? media,
    required String type,
  });
  // 21-delete group post
  Future<void> deleteGroupPost({
    required String groupId,
    required String postId,
  });
  // 22-edit group post
  Future<PostModel> updateGroupPost({
    required String groupId,
    required String postId,
    required String caption,
  });
  // 23-get group post
  Future<PostModel> getGroupPostById({
    required String groupId,
    required String postId,
  });
  // 24-get group posts
  Future<List<PostModel>> getGroupPosts({
    required String groupId,
    int page = 1,
  });
  // 25-get group feed
  Future<List<PostModel>> getGroupFeed({int page = 1});
  // 26-get my groups
  Future<List<GroupModel>> getMyGroups({int page = 1, String? search});
  // 27-get joined groups
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

  // 1- create group
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
      return GroupModel.fromJson(response['data']['group']);
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  //2- delete group
  @override
  Future<void> deleteGroup(String groupId) async =>
      await _simpleDelete("${ApiEndpoints.groups}/$groupId");

  // 3- update group
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

  // 4- get group
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

  // 5- get groups
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

  // 6- join group
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

  // 7- leave group
  @override
  Future<void> leaveGroup(String groupId) async =>
      await _simpleDelete("${ApiEndpoints.groups}/$groupId/leave");

  // 8- cancel join request
  @override
  Future<void> cancelJoinRequest(String groupId) async =>
      await _simpleDelete("${ApiEndpoints.groups}/$groupId/requests/cancel");

  // 9- get join requests
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

  // 10- accept join request
  @override
  Future<void> acceptJoinRequest({
    required String groupId,
    required String requestId,
  }) async => await api.post(
    "${ApiEndpoints.groups}/$groupId/requests/$requestId/accept",
    options: _getAuthOptions(),
  );

  // 11- decline join request
  @override
  Future<void> declineJoinRequest({
    required String groupId,
    required String requestId,
  }) async => await api.post(
    "${ApiEndpoints.groups}/$groupId/requests/$requestId/decline",
    options: _getAuthOptions(),
  );

  // 12- change member role
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

  // 13- kick member
  @override
  Future<void> kickMember({
    required String groupId,
    required String userId,
  }) async => await _memberAction(groupId, userId, "kick");

  // 14- ban member
  @override
  Future<void> banMember({
    required String groupId,
    required String userId,
  }) async => await _memberAction(groupId, userId, "ban");

  // 15- unban member
  @override
  Future<void> unbanMember({
    required String groupId,
    required String userId,
  }) async => await _memberAction(groupId, userId, "unban");

  // 16- get members
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

  // 17- get moderators
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

  // 18- get admins
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

  // 19- get banned members
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

  // 20- create group post
  @override
  Future<PostModel> createGroupPost({
    required String groupId,
    String? caption,
    List<XFile>? media,
    required String type,
  }) async {
    try {
      final formData = FormData.fromMap({
        'caption': caption ?? '',
        'type': type,
      });
      if (media != null) {
        for (var file in media) {
          if (kIsWeb) {
            final bytes = await file.readAsBytes();
            formData.files.add(
              MapEntry(
                'media',
                MultipartFile.fromBytes(bytes, filename: file.name),
              ),
            );
          } else {
            formData.files.add(
              MapEntry(
                'media',
                await MultipartFile.fromFile(file.path, filename: file.name),
              ),
            );
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

  // 21- delete group post
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

  // 22- edit group post
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

  // 23- get group post by id
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

  // 24- get group posts
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

  // 25- get group feed
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

  // 26 - get my groups
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

  // 27 - get joined groups
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
      final data = response['data']['groups'] as List;
      return data
          .where((item) => item != null)
          .map((e) => GroupModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

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
