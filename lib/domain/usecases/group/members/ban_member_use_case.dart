import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/group_repo.dart';
import 'package:dartz/dartz.dart';

class BanMemberUseCase {
  final GroupRepo groupRepo;
  BanMemberUseCase(this.groupRepo);

  Future<Either<Failure, String>> call({
    required String groupId,
    required String userId,
  }) async {
    return await groupRepo.banMember(groupId: groupId, userId: userId);
  }
}
