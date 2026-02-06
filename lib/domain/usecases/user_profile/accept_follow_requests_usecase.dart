import 'package:auth/core/errors/failure.dart';
import 'package:auth/data/models/user_model.dart';
import 'package:auth/domain/repositories/user_profile_repo.dart';
import 'package:dartz/dartz.dart';

class AcceptFollowRequestUsecase {
  final UserProfileRepo repository;

  AcceptFollowRequestUsecase(this.repository);

  Future<Either<Failure, UserModel>> call({
    required String requestId,
  }) async {
    return repository.acceptFollowRequest(
      requestId: requestId,
    );
  }
}
