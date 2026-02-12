import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/user_profile.dart';
import 'package:auth/domain/repositories/user_profile_repo.dart';
import 'package:dartz/dartz.dart';

class GetMyProfile {
  final UserProfileRepo repository;

  GetMyProfile(this.repository);

  Future<Either<Failure, UserProfile>> call() async {
    return await repository.getMyProfile();
  }
}