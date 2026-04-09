import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/user_profile_repo.dart';
import 'package:dartz/dartz.dart';

class UnsavePost {
  final UserProfileRepo repository;

  UnsavePost(this.repository);

  Future<Either<Failure, Unit>> call(String postId) async {
    return await repository.unsavePost(postId);
  }
}