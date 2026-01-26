import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/user_profile.dart';
import 'package:auth/domain/repositories/user_profile_repo.dart';
import 'package:dartz/dartz.dart';

class GetUserProfileInfoUsecase {
  final UserProfileRepo repository;

  GetUserProfileInfoUsecase({required this.repository});

  Future<Either<Failure, UserProfile>> call(String userId) async{
    return await repository.getUserProfileInfo(userId);
  }
}