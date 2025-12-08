import 'package:auth/domain/repositories/user_profile_repo.dart';

class UnfollowUserUsecase {
  final UserProfileRepo repository;

  UnfollowUserUsecase(this.repository);

  Future<void> execute({
    required String currentUserId,
    required String targetUserId,
  }) async {
    await repository.unfollowUser(
      currentUserId: currentUserId,
      targetUserId: targetUserId,
    );
  }
}
