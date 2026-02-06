import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/group_member.dart';
import 'package:auth/domain/repositories/group_repo.dart';
import 'package:dartz/dartz.dart';

class GetGroupMembersUseCase {
  final GroupRepo groupRepo;
  GetGroupMembersUseCase(this.groupRepo);

  Future<Either<Failure, List<GroupMember>>> call({
    required String groupId,
    required String role, // admins, moderators, members, banned
    int page = 1,
  }) async {
    return await groupRepo.getGroupMembers(
      groupId: groupId,
      role: role,
      page: page,
    );
  }
}
