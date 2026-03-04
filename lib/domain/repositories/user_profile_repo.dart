import 'dart:io';

import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/user_profile.dart';
import 'package:auth/domain/entities/user_profile_preview.dart';
import 'package:dartz/dartz.dart';

abstract class UserProfileRepo {
  Future<Either<Failure, UserProfile>> getMyProfile();

  Future<Either<Failure, UserProfile>> updateProfile({
    String? username,
    String? bio,
    File? avatarFile,
  });
  Future<Either<Failure, Unit>> changePassword(String currentPassword, String newPassword);
  Future<Either<Failure, List<UserProfilePreview>>> getSuggestions();
  Future<Either<Failure, List<Post>>> getLikedPostsIds();
}
