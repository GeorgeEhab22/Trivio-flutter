import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/group_repo.dart';
import 'package:dartz/dartz.dart';

class DeleteGroupUseCase {
  final GroupRepo groupRepo;
  DeleteGroupUseCase(this.groupRepo);

  Future<Either<Failure, String>> call({required String groupId}) async {
    if (groupId.isEmpty) {
      return const Left(ValidationFailure('Group ID is required'));
    }
    return await groupRepo.deleteGroup(groupId: groupId);
  }
}
