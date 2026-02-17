import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/group.dart';
import 'package:auth/domain/repositories/group_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class UpdateGroupUseCase {
  final GroupRepo groupRepo;
  UpdateGroupUseCase(this.groupRepo);

  Future<Either<Failure, Group>> call({
    required String groupId,
    String? name,
    String? description,
    XFile? coverImage,
    String? privacy,
  }) async {
    if (groupId.isEmpty) {
      return const Left(ValidationFailure('Invalid Group ID'));
    }

    return await groupRepo.updateGroup(
      groupId: groupId,
      name: name?.trim(),
      description: description?.trim(),
      coverImage: coverImage,
      privacy: privacy,
    );
  }
}
