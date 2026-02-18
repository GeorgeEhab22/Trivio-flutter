import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/repositories/post_repo.dart';
import 'package:dartz/dartz.dart';

class SearchPostsUseCase {
  final PostRepo repo;

  SearchPostsUseCase(this.repo);

  Future<Either<Failure, List<Post>>> call(String query) async {
    if (query.trim().isEmpty) {
      return const Left(ValidationFailure('Search query cannot be empty'));
    }

    return await repo.searchPosts(query);
  }
}
