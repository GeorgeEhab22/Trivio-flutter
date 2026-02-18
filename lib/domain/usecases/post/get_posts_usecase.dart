import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/repositories/post_repo.dart';
import 'package:dartz/dartz.dart';

class GetPostsUseCase {
  final PostRepo repo;

  GetPostsUseCase(this.repo);

  // later add recommendation posts , trending posts , following posts

  Future<Either<Failure, List<Post>>> call({
    int page = 1,
    int limit = 20,
  }) async {
    return await repo.fetchPosts(page: page, limit: limit);
  }
}
