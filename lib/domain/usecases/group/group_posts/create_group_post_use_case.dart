import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/group_post.dart';
import 'package:auth/domain/repositories/group_repo.dart';
import 'package:dartz/dartz.dart';

class CreateGroupPostUseCase {
  final GroupRepo groupRepo;
  CreateGroupPostUseCase(this.groupRepo);

  Future<Either<Failure, GroupPost>> call({
    required String groupId,
    String? caption,
    List<String>? media,
  }) async {
    final trimmedCaption = caption?.trim() ?? '';
    final hasMedia = media != null && media.isNotEmpty;

    if (trimmedCaption.isEmpty && !hasMedia) {
      return const Left(
        ValidationFailure('Post content cannot be empty. Add text or media.'),
      );
    }

    return await groupRepo.createGroupPost(
      groupId: groupId,
      caption: trimmedCaption,
      media: media,
    );
  }
}
