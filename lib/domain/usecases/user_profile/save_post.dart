import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/user_profile_repo.dart';
import 'package:dartz/dartz.dart';

class SavePost {
  final UserProfileRepo repository;

  SavePost(this.repository);

  Future<Either<Failure, Unit>> call(String postId) async {
    return await repository.savePost(postId);
  }
}