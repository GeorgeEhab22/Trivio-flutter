import 'package:auth/domain/entities/group.dart';
import 'package:auth/domain/entities/player.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/team.dart';

class DummyData {
  static final List<Group> dummyGroups = List.generate(
    8,
    (index) => const Group(
      groupId: '',
      groupName: 'Loading Group Name',
      groupCoverImage: null,
      groupDescription:
          'This is a long description placeholder to help skeletonizer draw the lines properly.',
      membersCount: 0,
      moderatorsCount: 0,
      adminsCount: 0,
    ),
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
  static final List<Post> dummyPosts = List.generate(
    5,
    (index) => const Post(
      postID: '',
      authorId: '',
      caption:
          'This is a placeholder for the post caption that should be long enough to show multiple lines of skeleton loading effect.',
      type: 'text',
    ),
  );
  static const Post dummyPost = Post(
    postID: '',
    authorId: '',
    caption: 'Loading more content...',
    type: 'text',
  );
  static final List<dynamic> dummyTeams = List.generate(
    15,
    (index) =>
        const Team(name: 'Loading Team Name', logo: '', id: '', league: ''),
  );
  static final List<dynamic> dummyPlayers = List.generate(
    15,
    (index) => const Player(
      name: 'Loading Player Name',
      playerImage: '',
      idTeam: '',
      id: '',
    ),
  );
}
