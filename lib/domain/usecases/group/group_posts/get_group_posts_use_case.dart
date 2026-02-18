import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/repositories/group_repo.dart';
import 'package:dartz/dartz.dart';

class GetGroupPostsUseCase {
  final GroupRepo groupRepo;
  GetGroupPostsUseCase(this.groupRepo);

  Future<Either<Failure, List<Post>>> call({
    required String groupId,
    int page = 1,
  }) async {
    return await groupRepo.getGroupPosts(groupId: groupId, page: page);
  }
}
