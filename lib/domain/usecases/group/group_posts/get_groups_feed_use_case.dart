import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/group_post.dart';
import 'package:auth/domain/repositories/group_repo.dart';
import 'package:dartz/dartz.dart';

class GetGroupsFeedUseCase {
  final GroupRepo groupRepo;
  GetGroupsFeedUseCase(this.groupRepo);

  Future<Either<Failure, List<GroupPost>>> call({int page = 1}) async {
    return await groupRepo.getGroupsFeed(page: page);
  }
}
