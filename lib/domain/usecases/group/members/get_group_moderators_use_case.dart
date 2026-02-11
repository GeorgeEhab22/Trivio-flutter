import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/group_member.dart';
import 'package:auth/domain/repositories/group_repo.dart';
import 'package:dartz/dartz.dart';

class GetGroupModeratorsUseCase {
  final GroupRepo groupRepo;
  GetGroupModeratorsUseCase(this.groupRepo);

  Future<Either<Failure, List<GroupMember>>> call({
    required String groupId,
    int page = 1,
  }) async {
    return await groupRepo.getGroupModerators(
      groupId: groupId,
      page: page,
    );
  }
}
