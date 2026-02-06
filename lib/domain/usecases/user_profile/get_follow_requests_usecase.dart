import 'package:auth/core/errors/failure.dart';
import 'package:auth/data/models/user_model.dart';
import 'package:auth/domain/repositories/user_profile_repo.dart';
import 'package:dartz/dartz.dart';

class GetFollowRequestsUsecase {
  final UserProfileRepo repository;

  GetFollowRequestsUsecase(this.repository);

  Future<Either<Failure, List<UserModel>>> call() async {
    return repository.getFollowRequests();
  }
}
