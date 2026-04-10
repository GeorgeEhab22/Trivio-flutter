import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/group_repo.dart';
import 'package:dartz/dartz.dart';

class GetUserGroupRoleUseCase {
  final GroupRepo repo;

  GetUserGroupRoleUseCase(this.repo);

  Future<Either<Failure, String>> call(String groupId) async {
    return await repo.getUserGroupRole(groupId: groupId);
  }
}