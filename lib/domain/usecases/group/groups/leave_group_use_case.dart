import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/group_repo.dart';
import 'package:dartz/dartz.dart';

class LeaveGroupUseCase {
  final GroupRepo groupRepo;
  LeaveGroupUseCase(this.groupRepo);

  Future<Either<Failure, String>> call({required String groupId}) async {
    if (groupId.isEmpty) {
      return const Left(ValidationFailure('Invalid Group ID'));
    }
    return await groupRepo.leaveGroup(groupId: groupId);
  }
}
