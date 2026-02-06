import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/group_repo.dart';
import 'package:dartz/dartz.dart';

class DeclineJoinRequestUseCase {
  final GroupRepo groupRepo;
  DeclineJoinRequestUseCase(this.groupRepo);

  Future<Either<Failure, String>> call({
    required String groupId,
    required String userId,
  }) async {
    if (userId.isEmpty) {
      return const Left(ValidationFailure('User ID is required'));
    }
    return await groupRepo.declineJoinRequest(groupId: groupId, userId: userId);
  }
}
