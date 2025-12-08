import 'package:auth/domain/repositories/user_profile_repo.dart';

class FollowUserUsecase {
  final UserProfileRepo repository;

  FollowUserUsecase(this.repository);

  Future<void> execute({
    required String currentUserId,
    required String targetUserId,
  }) async {
    await repository.followUser(
      currentUserId: currentUserId,
      targetUserId: targetUserId,
    );
  }
}
