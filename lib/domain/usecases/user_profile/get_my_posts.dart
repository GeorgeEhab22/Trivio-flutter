import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/user_profile_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:auth/domain/entities/post.dart';

class GetMyPostsUseCase {
  final UserProfileRepo repository;

  GetMyPostsUseCase(this.repository);

  Future<Either<Failure, List<Post>>> call() async {
    return await repository.getMyPosts();
  }
}