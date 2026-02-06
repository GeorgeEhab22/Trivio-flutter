import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/group_repo.dart';
import 'package:dartz/dartz.dart';

class UnbanMemberUseCase {
  final GroupRepo groupRepo;
  UnbanMemberUseCase(this.groupRepo);

  Future<Either<Failure, String>> call({
    required String groupId,
    required String userId,
  }) async {
    return await groupRepo.unbanMember(groupId: groupId, userId: userId);
  }
}
