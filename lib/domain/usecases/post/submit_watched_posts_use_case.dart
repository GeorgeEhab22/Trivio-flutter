import 'package:auth/domain/repositories/post_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:auth/core/errors/failure.dart';

class SubmitWatchedPostsUseCase {
  final PostRepo repository;
  const SubmitWatchedPostsUseCase(this.repository,  );

  Future<Either<Failure, Unit>> call(List<String> postIds) async {
    if (postIds.isEmpty) return const Right(unit);
    return repository.submitWatchedPosts((postIds));
  }
}
