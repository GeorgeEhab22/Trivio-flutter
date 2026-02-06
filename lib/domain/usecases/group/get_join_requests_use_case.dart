import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/group_member.dart';
import 'package:auth/domain/repositories/group_repo.dart';
import 'package:dartz/dartz.dart';

class GetJoinRequestsUseCase {
  final GroupRepo groupRepo;
  GetJoinRequestsUseCase(this.groupRepo);

  Future<Either<Failure, List<GroupMember>>> call({
    required String groupId,
    int page = 1,
  }) async {
    final int validPage = page < 1 ? 1 : page;
    return await groupRepo.getJoinRequests(groupId: groupId, page: validPage);
  }
}
