import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/group.dart';
import 'package:auth/domain/repositories/group_repo.dart';
import 'package:dartz/dartz.dart';

class GetGroupsUseCase {
  final GroupRepo groupRepo;
  GetGroupsUseCase(this.groupRepo);

  Future<Either<Failure, List<Group>>> call({
    int page = 1,
    String? search,
  }) async {
    final int validPage = page < 1 ? 1 : page;
    return await groupRepo.getGroups(page: validPage, search: search);
  }
}
