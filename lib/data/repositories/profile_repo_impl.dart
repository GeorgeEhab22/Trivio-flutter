import 'package:auth/core/errors/failure.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/datasource/profile_remote_datasource.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/user_profile.dart';
import 'package:auth/domain/entities/user_profile_preview.dart';
import 'package:auth/domain/repositories/user_profile_repo.dart';
import 'package:dartz/dartz.dart';

class UserProfileRepositoryImpl implements UserProfileRepo {
  final ProfileRemoteDataSource remoteDataSource;

  UserProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserProfile>> getMyProfile() async {
    try {
      final model = await remoteDataSource.getMyProfile();
      final entity = model.toEntity();
      // final dummyProfile = UserProfile(
      //   id: "65f1a2b3c4d5e6f7890abc12",
      //   name: "John Doe",
      //   email: "john.doe@example.com",
      //   avatar: "https://example.com/avatar.jpg",
      //   followersCount: 42,
      //   followingCount: 15,
      //   postsCount: 10,
      // );
      return Right(entity);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfile({
    String? username,
    String? bio,
    dynamic avatarFile,
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

 
}
