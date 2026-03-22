import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/user_profile.dart';
import 'package:auth/domain/repositories/user_profile_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfile {
  final UserProfileRepo repository;
  UpdateProfile(this.repository);

  Future<Either<Failure, UserProfile>> call({
    String? username,
    String? bio,
    XFile? avatarFile,
  }) async {
    return await repository.updateProfile(
      username: username,
      bio: bio,
      avatarFile: avatarFile,
    );
  }
}