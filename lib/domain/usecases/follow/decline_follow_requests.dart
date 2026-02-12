import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/follow_repo.dart';
import 'package:dartz/dartz.dart';

class DeclineFollowRequest {
  final FollowRepo repository;

  DeclineFollowRequest(this.repository);

  Future<Either<Failure, void>> call({required String requestId}) async {
    return await repository.declineFollowRequest(requestId: requestId);
  }
}
