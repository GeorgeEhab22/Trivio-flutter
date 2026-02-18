import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/follow_request.dart';
import 'package:auth/domain/repositories/follow_repo.dart';
import 'package:dartz/dartz.dart';

class GetMyFollowRequests {
  final FollowRepo repository;

  GetMyFollowRequests(this.repository);

  Future<Either<Failure, List<FollowRequest>>> call() async {
    return await repository.getMyFollowRequests();
  }
}
