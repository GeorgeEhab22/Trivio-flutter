import 'package:auth/core/errors/failure.dart';
import 'package:auth/core/validator.dart';
import 'package:auth/domain/entities/comment.dart';
import 'package:auth/domain/repositories/comment_repo.dart';
import 'package:dartz/dartz.dart';

class MentionUsersInCommentUseCase {
  final CommentRepository repository;

  MentionUsersInCommentUseCase(this.repository);

  Future<Either<Failure, Comment>> call({
    required String commentId,
    required List<String> mentionedUserIds,
  }) async {
    if (commentId.trim().isEmpty) {
      return const Left(ValidationFailure('Comment ID is required'));
    }
    if (!Validator.isValidId(commentId)) {
      return const Left(ValidationFailure('Invalid Comment ID'));
    }

    if (mentionedUserIds.isEmpty) {
      return const Left(ValidationFailure('mentionedUserIds cannot be empty'));
    }
    for (final id in mentionedUserIds) {
      if (!Validator.isValidId(id)) {
        return const Left(ValidationFailure('One or more mentioned user IDs are invalid'));
      }
    }

    return await repository.mentionUsersInComment(
      commentId: commentId,
      mentionedUserIds: mentionedUserIds,
    );
  }
}
