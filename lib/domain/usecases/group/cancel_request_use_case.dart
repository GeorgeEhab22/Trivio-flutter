import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/group_repo.dart';
import 'package:dartz/dartz.dart';

class CancelRequestUseCase {
  final GroupRepo groupRepo;
  CancelRequestUseCase(this.groupRepo);

  Future<Either<Failure, String>> call({required String groupId, required String userId}) async {
    if (groupId.isEmpty) {
      return const Left(ValidationFailure('Invalid Group ID'));
    }

    return await groupRepo.cancelRequest(groupId: groupId, userId: userId);
  }
}
