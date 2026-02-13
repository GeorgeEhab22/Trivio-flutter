import 'package:auth/data/models/follow_model.dart';
import 'package:auth/data/models/follow_request_model.dart';
import 'package:auth/domain/entities/follow.dart';
import 'package:auth/domain/entities/user_profile_preview.dart';

class DummyFollowData {
  // 1. A Preview Object (Commonly used in lists)
  static final janeDoePreview = UserProfilePreview(
    id: "user_002",
    name: "Jane Doe",
    avatarUrl: "https://i.pravatar.cc/150?u=jane",
  );

  static final johnSmithPreview = UserProfilePreview(
    id: "user_003",
    name: "John Smith",
    avatarUrl: "https://i.pravatar.cc/150?u=john",
  );

  // 2. Dummy FollowModel (For Following/Followers lists)
  static final followModel = FollowModel(
    id: "follow_abc_123",
    user: UserReference.fromJson({
      "_id": "user_001",
      "name": "My Account",
      "avatar": "https://i.pravatar.cc/150?u=me"
    }),
    follower: UserReference.fromJson({
      "_id": "user_002",
      "name": "Jane Doe",
      "avatar": "https://i.pravatar.cc/150?u=jane"
    }),
    status: "following",
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
  );

  // 3. Dummy FollowRequestModel (For the "Requests" screen)
  static final followRequest = FollowRequestModel(
    id: "req_xyz_789",
    userId: "user_001", // Me
    followerId: "user_003",
    follower: johnSmithPreview,
    status: "pending",
  );

  // 4. A list for paginated testing
  static List<FollowModel> getDummyFollowersList() {
    return List.generate(10, (index) => FollowModel(
      id: "follow_id_$index",
      user: UserReference.fromJson("my_id"),
      follower: UserReference.fromJson({
        "_id": "user_$index",
        "name": "User $index",
        "avatar": "https://i.pravatar.cc/150?u=$index"
      }),
      status: "following",
    ));
  }
}