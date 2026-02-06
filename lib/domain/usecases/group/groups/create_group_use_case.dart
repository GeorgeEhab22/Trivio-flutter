import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/group.dart';
import 'package:auth/domain/repositories/group_repo.dart';
import 'package:dartz/dartz.dart';

class CreateGroupUseCase {
  final GroupRepo groupRepo;
  CreateGroupUseCase(this.groupRepo);

  Future<Either<Failure, Group>> call({
    required String name,
    required String description,
    required String coverImage,
    String? privacy,
  }) async {
    if (name.trim().isEmpty) {
      return const Left(ValidationFailure('Group name cannot be empty'));
    }

    if (description.trim().length < 10) {
      return const Left(
        ValidationFailure('Description must be at least 10 characters long'),
      );
    }

    if (coverImage.isEmpty) {
      return const Left(ValidationFailure('Please select a group cover image'));
    }

    return await groupRepo.createGroup(
      name: name.trim(),
      description: description.trim(),
      coverImage: coverImage,
      privacy: privacy ?? "private",
    );
  }
}
