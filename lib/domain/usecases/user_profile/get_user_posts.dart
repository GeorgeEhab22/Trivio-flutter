import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/repositories/user_profile_repo.dart';
import 'package:dartz/dartz.dart';

class GetUserPostsUseCase {
  final UserProfileRepo repository;

  GetUserPostsUseCase(this.repository);

  Future<Either<Failure, List<Post>>> call(String userId) async {
    return await repository.getUserPostsById(userId);
  }
}