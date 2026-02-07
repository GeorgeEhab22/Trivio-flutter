import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/group_repo.dart';
import 'package:dartz/dartz.dart';

class DeleteGroupPostUseCase {
  final GroupRepo groupRepo;
  DeleteGroupPostUseCase(this.groupRepo);

  Future<Either<Failure, String>> call({
    required String groupId,
    required String userId,
    required String postId,
  }) async {
    return await groupRepo.deleteGroupPost(groupId: groupId,userId: userId,postId: postId);
  }
}
