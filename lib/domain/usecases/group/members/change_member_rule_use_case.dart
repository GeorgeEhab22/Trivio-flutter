import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/group_repo.dart';
import 'package:dartz/dartz.dart';

class ChangeMemberRoleUseCase {
  final GroupRepo groupRepo;
  ChangeMemberRoleUseCase(this.groupRepo);

  Future<Either<Failure, String>> call({
    required String groupId,
    required String userId,
    required String newRole,
  }) async {
    final validRoles = ['admin', 'moderator', 'member'];
    if (!validRoles.contains(newRole.toLowerCase())) {
      return const Left(ValidationFailure('Invalid role specified'));
    }
    return await groupRepo.changeMemberRole(
      groupId: groupId,
      userId: userId,
      newRole: newRole.toLowerCase(),
    );
  }
}
