import 'package:auth/domain/entities/group.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/group_member.dart';
import 'package:auth/domain/entities/join_request.dart';

class DummyData {
  // Groups
  static final List<Group> dummyGroups = List.generate(
    8,
    (index) => dummyGroup,
  );

  static const Group dummyGroup = Group(
    groupId: '',
    groupName: 'Loading Group Name',
    groupCoverImage: null,
    groupDescription:
        'This is a placeholder for the group description that should be long enough to show three or four lines of skeleton loading effect.',
    membersCount: 0,
    moderatorsCount: 0,
    adminsCount: 0,
  );

  // Posts
  static final List<Post> dummyPosts = List.generate(5, (index) => dummyPost);

  static const Post dummyPost = Post(
    postID: '',
    authorId: '',
    caption: 'Loading more content...',
    type: 'text',
  );

  // Members (Used for Members, Admins, Moderators, and Banned)
  static final List<GroupMember> dummyMembers = List.generate(
    10,
    (index) => dummyMember,
  );

  static const GroupMember dummyMember = GroupMember(
    userId: '',
    userName: 'Loading Member Name',
    profileImageUrl: null,
    role: 'member',
  );

  // Join Requests
  static final List<JoinRequest> dummyRequests = List.generate(
    6,
    (index) => dummyRequest,
  );

  static const JoinRequest dummyRequest = JoinRequest(
    requestId: '',
    userId: '',
    userName: 'Loading User Name',
    userEmail: 'loading.email@example.com',
    groupId: '',
    status: 'pending',
  );
}
