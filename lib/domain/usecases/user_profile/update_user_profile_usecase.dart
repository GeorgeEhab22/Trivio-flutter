import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/user_profile.dart';
import 'package:auth/domain/repositories/user_profile_repo.dart';
import 'package:dartz/dartz.dart';

class UpdateUserProfileUsecase {
  final UserProfileRepo repository;

  UpdateUserProfileUsecase(this.repository);

  Future<Either<Failure, UserProfile>> call({
    required String userId,
    String? username,
    String? about,
    String? profileImageUrl,
  }) async {
    return await repository.updateUserProfile(
      userId: userId,
      username: username,
      about: about,
      profileImageUrl: profileImageUrl,
    );
  }
}
