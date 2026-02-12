import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/follow.dart';
import 'package:auth/domain/repositories/follow_repo.dart';
import 'package:dartz/dartz.dart';

class AcceptFollowRequest {
  final FollowRepo repository;

  AcceptFollowRequest(this.repository);

  Future<Either<Failure, Follow>> call({required String requestId}) async {
    return await repository.acceptFollowRequest(requestId: requestId);
  }
}
