import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/repositories/group_repo.dart';
import 'package:dartz/dartz.dart';

class EditGroupPostUseCase {
  final GroupRepo groupRepo;
  EditGroupPostUseCase(this.groupRepo);

  Future<Either<Failure, Post>> call({
    required String groupId,
    required String postId,
    required String newCaption,
  }) async {
    return await groupRepo.editGroupPost(
      groupId: groupId,
      postId: postId,
      newCaption: newCaption.trim(),
    );
  }
}