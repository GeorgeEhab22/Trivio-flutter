import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/user_profile.dart';
import 'package:dartz/dartz.dart';

abstract class UserProfileRepo {

  //get userinfo without the list of posts first time
  Future<Either<Failure, UserProfile>> getUserProfileInfo(String userId); 

  Future<Either<Failure,UserProfile>> updateUserProfile({
    required String userId,
    String? username,
    String? about,
    String? profileImageUrl,
  });

  //get user's posts - paginated (?)
  Future<Either<Failure,List<Post>>> getUserPosts({
    required String userId,
    int limit = 10,
    String? lastPostId, //dunno about this one, maybe some index better?
  });

  //follow another user (+1 follower/following)
  Future<void> followUser({
    required String currentUserId,
    required String targetUserId,
  });

  // unfollow another user (-1 follower/following)
  Future<void> unfollowUser({
    required String currentUserId,
    required String targetUserId,
  });

}
