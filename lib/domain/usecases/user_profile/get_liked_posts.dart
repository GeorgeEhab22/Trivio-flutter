import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/repositories/user_profile_repo.dart';
import 'package:dartz/dartz.dart';

class GetLikedPostsUseCase {
  final UserProfileRepo repository;

  GetLikedPostsUseCase(this.repository);

  Future<Either<Failure, List<Post>>> call() async {
    return await repository.getLikedPosts();
  }
}