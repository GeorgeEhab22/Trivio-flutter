import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/group_repo.dart';
import 'package:dartz/dartz.dart';

class KickMemberUseCase {
  final GroupRepo groupRepo;
  KickMemberUseCase(this.groupRepo);

  Future<Either<Failure, String>> call({
    required String groupId,
    required String userId,
  }) async {
    return await groupRepo.kickMember(groupId: groupId, userId: userId);
  }
}
