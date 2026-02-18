import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/repositories/group_repo.dart';
import 'package:dartz/dartz.dart';

class GetGroupsPostsFeedUseCase {
  final GroupRepo groupRepo;
  GetGroupsPostsFeedUseCase(this.groupRepo);

  Future<Either<Failure, List<Post>>> call({int page = 1}) async {
    return await groupRepo.getGroupsFeed(page: page);
  }
}
