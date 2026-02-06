import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/user_profile_repo.dart';
import 'package:dartz/dartz.dart';

class DeclineFollowRequestUsecase {
  final UserProfileRepo repository;

  DeclineFollowRequestUsecase(this.repository);

  Future<Either<Failure, Unit>> call({
    required String requestId,
  }) async {
    return repository.declineFollowRequest(
      requestId: requestId,
    );
  }
}
