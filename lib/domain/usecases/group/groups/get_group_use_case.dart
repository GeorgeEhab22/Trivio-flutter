import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/group.dart';
import 'package:auth/domain/repositories/group_repo.dart';
import 'package:dartz/dartz.dart';

class GetGroupDetailsUseCase {
  final GroupRepo groupRepo;
  GetGroupDetailsUseCase(this.groupRepo);
  Future<Either<Failure, Group>> call({required String groupId}) async {
    return await groupRepo.getGroup(groupId: groupId);
  }
}
