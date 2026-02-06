import 'package:auth/core/errors/failure.dart';
import 'package:auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

abstract class UserProfileRepo {
  Future<Either<Failure, List<UserModel>>> getFollowRequests();
  Future<Either<Failure, UserModel>> acceptFollowRequest({
    required String requestId,
  });
  Future<Either<Failure, Unit>> declineFollowRequest({
    required String requestId,
  });
}
