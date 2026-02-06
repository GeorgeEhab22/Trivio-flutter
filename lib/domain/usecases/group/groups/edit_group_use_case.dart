import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/group.dart';
import 'package:auth/domain/repositories/group_repo.dart';
import 'package:dartz/dartz.dart';

class UpdateGroupUseCase {
  final GroupRepo groupRepo;
  UpdateGroupUseCase(this.groupRepo);

  Future<Either<Failure, Group>> call({
    required String groupId,
    String? name,
    String? description,
    String? coverImage,
    String? privacy,
  }) async {
    if (groupId.isEmpty) {
      return const Left(ValidationFailure('Invalid Group ID'));
    }

    if (name != null && name.trim().isEmpty) {
      return const Left(ValidationFailure('Name cannot be empty'));
    }

    if (description != null && description.trim().length < 10) {
      return const Left(
        ValidationFailure('Description must be at least 10 characters long'),
      );
    }

    return await groupRepo.updateGroup(
      groupId: groupId,
      name: name?.trim(),
      description: description?.trim(),
      coverImage: coverImage,
      privacy: privacy ?? "private",
    );
  }
}
