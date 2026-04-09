import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/user_profile.dart';
import 'package:auth/domain/entities/user_profile_preview.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

abstract class UserProfileRepo {
  Future<Either<Failure, UserProfile>> getMyProfile();
  Future<Either<Failure, UserProfile>> getUserProfileById(String userId);
  Future<Either<Failure, UserProfile>> updateProfile({
    String? username,
    String? bio,
    XFile? avatarFile,
  });
  Future<Either<Failure, Unit>> changePassword(String currentPassword, String newPassword);
  Future<Either<Failure, List<UserProfilePreview>>> getSuggestions();
  Future<Either<Failure, List<Post>>> getLikedPostsIds();
  Future<Either<Failure, List<Post>>> getLikedPosts();
  Future<Either<Failure, List<Post>>> getMyPosts();
  Future<Either<Failure, List<String>>> getSavedPosts();
  Future<Either<Failure, Unit>> savePost(String postId);
  Future<Either<Failure, Unit>> unsavePost(String postId);
  Future<Either<Failure, List<Post>>> getUserPostsById(String userId);
}
