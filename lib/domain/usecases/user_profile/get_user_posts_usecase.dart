import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/repositories/user_profile_repo.dart';
import 'package:dartz/dartz.dart';

class GetUserPostsUsecase {
  final UserProfileRepo repository;

  GetUserPostsUsecase(this.repository);

  Future<Either<Failure, List<Post>>> call({
    required String userId,
    int limit = 10,
    String? lastPostId,
  }) async {
    return await repository.getUserPosts(
      userId: userId,
      limit: limit,
      lastPostId: lastPostId,
    );
  }
}
