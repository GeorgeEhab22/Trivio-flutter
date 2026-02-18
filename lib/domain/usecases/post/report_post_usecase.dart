import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/post_repo.dart';
import 'package:dartz/dartz.dart';

class ReportPostUseCase {
  final PostRepo repo;

  ReportPostUseCase(this.repo);

  Future<Either<Failure,void>> call({
    required String postId,
    required String userId,
     required String reason,
  }) async {
    if (postId.trim().isEmpty) {
      return const Left(ValidationFailure('Post ID is required'));
    }

    if (userId.trim().isEmpty) {
      return const Left(ValidationFailure('User ID is required'));
    }

    if (reason.trim().isEmpty) {
      return const Left(ValidationFailure('Reason is required'));
    }

    return await repo.reportPost(
      postId: postId,
      userId: userId,
      reason: reason,
    );
  }
}
