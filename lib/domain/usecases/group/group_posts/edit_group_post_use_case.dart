import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/group_post.dart';
import 'package:auth/domain/repositories/group_repo.dart';
import 'package:dartz/dartz.dart';

class EditGroupPostUseCase {
  final GroupRepo groupRepo;
  EditGroupPostUseCase(this.groupRepo);

  Future<Either<Failure, GroupPost>> call({
    required String groupId,
    required String userId,
    required String postId,
    required String newCaption,
    List<String>? media,
  }) async {
    if (newCaption.trim().isEmpty && (media == null || media.isEmpty)) {
      return const Left(ValidationFailure('Updated post cannot be empty'));
    }
    return await groupRepo.editGroupPost(
      groupId: groupId,
      userId: userId,
      postId: postId,
      newCaption: newCaption.trim(),
      media: media,
    );
  }
}
