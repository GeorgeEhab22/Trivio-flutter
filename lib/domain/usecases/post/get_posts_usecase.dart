import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/repositories/post_repo.dart';
import 'package:dartz/dartz.dart';

class GetPostsUseCase {
  final PostRepo repo;

  GetPostsUseCase(this.repo);


  Future<Either<Failure, List<Post>>> call({
   
    int limit = 20,
  }) async {
    return await repo.fetchPosts( limit: limit);
  }
}
