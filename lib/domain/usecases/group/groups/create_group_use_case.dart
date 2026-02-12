import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/group.dart';
import 'package:auth/domain/repositories/group_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class CreateGroupUseCase {
  final GroupRepo groupRepo;
  CreateGroupUseCase(this.groupRepo);

  Future<Either<Failure, Group>> call({
    required String name,
    required String description,
    XFile? coverImage,
  }) async {
    if (name.trim().isEmpty) {
      return const Left(ValidationFailure('Group name cannot be empty'));
    }

    if (description.trim().isEmpty) {
      return const Left(
        ValidationFailure('Group description cannot be empty'),
      );
    }


    return await groupRepo.createGroup(
      name: name.trim(),
      description: description.trim(),
      coverImage: coverImage,
    );
  }
}
