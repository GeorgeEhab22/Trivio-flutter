import 'package:auth/core/errors/failure.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/datasource/profile_remote_datasource.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/user_profile.dart';
import 'package:auth/domain/entities/user_profile_preview.dart';
import 'package:auth/domain/repositories/user_profile_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileRepositoryImpl implements UserProfileRepo {
  final ProfileRemoteDataSource remoteDataSource;

  UserProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserProfile>> getMyProfile() async {
    try {
      final model = await remoteDataSource.getMyProfile();
      final entity = model.toEntity();
      return Right(entity);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
@override
  Future<Either<Failure, UserProfile>> getUserProfileById(String userId) async {
    try {
      final model = await remoteDataSource.getUserProfileById(userId);
      final entity = model.toEntity();
      return Right(entity);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
  @override
  Future<Either<Failure, UserProfile>> updateProfile({
    String? username,
    String? bio,
    XFile? avatarFile,
  }) async {
    try {
      final model = await remoteDataSource.updateProfile(
        username: username,
        bio: bio,
        avatarFile: avatarFile,
      );
      final entity = model.toEntity();
      return Right(entity);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await remoteDataSource.changePassword(currentPassword, newPassword);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<UserProfilePreview>>> getSuggestions() async {
    try {
      final suggestions = await remoteDataSource.getSuggestions();
      return Right(suggestions);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getLikedPostsIds() async {
    try {
      final likedPostsIds = await remoteDataSource.getLikedPostsIds();
      return Right(likedPostsIds);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getLikedPosts() async {
    try {
      final likedPosts = await remoteDataSource.getLikedPosts();
      return Right(likedPosts);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
Future<Either<Failure, List<Post>>> getMyPosts() async {
  try {
    final posts = await remoteDataSource.getMyPosts();
    return Right(posts);
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  } catch (e) {
    return Left(ServerFailure('Unexpected error loading posts: $e'));
  }
}

  @override
  Future<Either<Failure, List<String>>> getSavedPosts() async {
    try {
      final posts = await remoteDataSource.getSavedPosts();
      return Right(posts);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error loading saved posts: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> savePost(String postId) async {
    try {
      await remoteDataSource.savePost(postId);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> unsavePost(String postId) async {
    try {
      await remoteDataSource.unsavePost(postId);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
