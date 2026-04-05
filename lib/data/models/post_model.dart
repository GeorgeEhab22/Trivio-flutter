import 'package:auth/core/json_parser.dart';
import 'package:auth/data/models/reaction_model.dart';
import 'package:auth/domain/entities/mentions.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/reaction.dart';
import 'package:auth/domain/entities/reaction_type.dart';

class PostModel extends Post {
  final int updateCount;
  final int views;
  final DummyReactionCounter reactionCounts;

  const PostModel({
    required super.postID,
    required this.updateCount,
    required this.reactionCounts,
    required super.media,
    required super.authorId,
    required super.authorName,
    required super.authorImage,
    required super.type,
    super.caption,
    super.location,
    super.mentions,
    this.views = 0,
    super.flagged,
    super.groupID,
    super.groupName,
    super.groupCoverImage,
    super.commentsCount = 0,
    super.reactions = const [],
    super.reactionsCount = 0,
    super.userReaction = ReactionType.none,
    super.reactionCountsByType = const <ReactionType, int>{},
    required super.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> raw =
        (json['data'] != null && json['data']['post'] != null)
        ? json['data']['post'] as Map<String, dynamic>
        : json;

    final dummyReactions = _parseReactionCounter(raw['reactionCounts']);

    final dynamic groupData = raw['groupID'];
    String? gID;
    String? gName;
    String? gCover;

    if (groupData is String) {
      gID = groupData;
    } else if (groupData is Map<String, dynamic>) {
      gID = groupData['_id'];
      gName = groupData['name'];
      gCover = groupData['coverImage'] ?? groupData['logo'];
    }

    //TODO : remove when backend is fixed to add mobile ip
    // and change to your ip
    if (gCover != null && gCover.contains('localhost')) {
      gCover = gCover.replaceAll('localhost', '192.168.1.28');
    }
    final dynamic authorData = raw['authorID'] ?? raw['authorId'];
    String aId = '';
    String? aName;
    String? aImage;

    if (authorData is String) {
      aId = authorData;
    } else if (authorData is Map<String, dynamic>) {
      aId = authorData['_id'] ?? '';
      aName = authorData['username'] ?? authorData['name'];
      aImage = authorData['avatar'] ?? authorData['profilePicture'];

      if (aImage != null && aImage.contains('localhost')) {
        aImage = aImage.replaceAll('localhost', '192.168.1.28');
      }
    }

    final userReaction = JsonParser.parseReactionType(
      raw['userReaction'] ?? raw['myReaction'] ?? raw['currentUserReaction'],
    );

    final mentionsJson = raw['mentions'] as List<dynamic>? ?? [];
    final userIds = <String>[];
    final usernames = <String>[];

    for (final m in mentionsJson) {
      final map = m as Map<String, dynamic>;
      userIds.add(map['_id'] as String? ?? '');
      usernames.add(map['username'] as String? ?? '');
    }

    final mentions = Mentions(userIds: userIds, usernames: usernames);

    //TODO: remove when backend is fixed to add mobile ip and change to your ip and un comment the above code
    final mediaList = (raw['media'] as List<dynamic>? ?? []).map((m) {
      String url = m as String;

      // if (url.contains('localhost') || url.contains('192.168.1.5')) {
      //   if (url.toLowerCase().endsWith('.mp4') ||
      //       url.toLowerCase().endsWith('.mov') ||
      //       url.toLowerCase().endsWith('.webm')) {
      //     return 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';
      //   }

      //   return url.replaceAll('localhost', '192.168.1.5');
      // }

      return url;
    }).toList();

    return PostModel(
      postID: JsonParser.parseString(raw['_id']),
      updateCount: JsonParser.parseInt(raw['__v']),
      authorId: aId,
      authorName: aName,
      authorImage: aImage,
      type: JsonParser.parseString(raw['type'], fallback: 'public'),
      caption: JsonParser.parseString(raw['caption']),
      location: JsonParser.parseString(raw['location']),
      views: JsonParser.parseInt(raw['views']),
      flagged: raw['flagged'],
      media: mediaList,
      mentions: mentions,

      groupID: gID,
      groupName: gName,
      groupCoverImage: gCover,

      reactions: _parseReactions(raw['reactions']),
      reactionCounts: dummyReactions,
      reactionCountsByType: JsonParser.mapReactionCounts(raw['reactionCounts']),

      reactionsCount: _calculateTotalReactions(raw, dummyReactions),
      userReaction: userReaction,

      //TODO: Handle commentsCount properly
      commentsCount: JsonParser.parseInt(
        raw['commentsCount'] ?? raw['comments_count'] ?? raw['repliesCount'],
      ),

      createdAt: raw['createdAt'] != null
          ? DateTime.parse(raw['createdAt'] as String)
          : DateTime.now(),
    );
  }

  static DummyReactionCounter _parseReactionCounter(dynamic map) {
    final m = map is Map<String, dynamic> ? map : <String, dynamic>{};
    return DummyReactionCounter(
      likesCount: JsonParser.parseInt(m['like']),
      lovesCount: JsonParser.parseInt(m['love']),
      hahaCount: JsonParser.parseInt(m['haha']),
      sadCount: JsonParser.parseInt(m['sad']),
      angryCount: JsonParser.parseInt(m['angry']),
      wowCount: JsonParser.parseInt(m['wow']),
      goalCount: JsonParser.parseInt(m['goal']),
      offsideCount: JsonParser.parseInt(m['offside']),
    );
  }

  static List<Reaction> _parseReactions(dynamic list) {
    if (list is! List) return [];
    return list
        .whereType<Map<String, dynamic>>()
        .map((r) => ReactionModel.fromJson(r).toEntity())
        .toList();
  }

  static int _calculateTotalReactions(
    Map<String, dynamic> raw,
    DummyReactionCounter dummy,
  ) {
    final count = JsonParser.parseInt(raw['reactionsCount']);
    if (count > 0) return count;
    return dummy.total > 0 ? dummy.total : 0;
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': postID,
      '__v': updateCount,
      'authorID': authorId,
      'type': type,
      'caption': caption,
      'mentions': [
        if (mentions != null)
          for (int i = 0; i < mentions!.userIds.length; i++)
            {'_id': mentions!.userIds[i], 'username': mentions!.usernames[i]},
      ],
      'media': media,
      'location': location,
      'views': views,
      'flagged': flagged,
      'reactionCounts': {
        'like': reactionCounts.likesCount,
        'love': reactionCounts.lovesCount,
        'haha': reactionCounts.hahaCount,
        'sad': reactionCounts.sadCount,
        'angry': reactionCounts.angryCount,
        'wow': reactionCounts.wowCount,
        'goal': reactionCounts.goalCount,
        'offside': reactionCounts.offsideCount,
      },
      'reactionsCount': reactionsCount,
      'userReaction': userReaction.name,
      'groupID': groupID,
      'groupName': groupName,
      'groupCoverImage': groupCoverImage,
      'commentsCount': commentsCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Post toEntity() {
    return Post(
      authorId: authorId,
      authorName: authorName,
      authorImage: authorImage,
      type: type,
      caption: caption,
      mentions: mentions,
      location: location,
      media: media,
      flagged: flagged,
      reactions: reactions,
      reactionsCount: reactionsCount,
      userReaction: userReaction,
      postID: postID,
      groupID: groupID,
      groupName: groupName,
      groupCoverImage: groupCoverImage,
      commentsCount: commentsCount,
      reactionCountsByType: JsonParser.mapReactionCounts(
        toJson()['reactionCounts'],
      ),
      createdAt: createdAt,
    );
  }

  factory PostModel.fromEntity(Post post) {
    return PostModel(
      postID: post.postID,
      updateCount: 0,
      authorId: post.authorId,
      authorName: post.authorName,
      authorImage: post.authorImage,
      type: post.type,
      caption: post.caption,
      mentions: post.mentions,
      media: post.media ?? const [],
      reactions: post.reactions ?? const [],
      reactionsCount: post.reactionsCount,
      userReaction: post.userReaction,
      reactionCounts: DummyReactionCounter(
        likesCount:
            post.reactionCountsByType[ReactionType.like] ?? post.reactionsCount,
        lovesCount: post.reactionCountsByType[ReactionType.love] ?? 0,
        hahaCount: post.reactionCountsByType[ReactionType.haha] ?? 0,
        sadCount: post.reactionCountsByType[ReactionType.sad] ?? 0,
        angryCount: post.reactionCountsByType[ReactionType.angry] ?? 0,
        wowCount: post.reactionCountsByType[ReactionType.wow] ?? 0,
        goalCount: post.reactionCountsByType[ReactionType.goal] ?? 0,
        offsideCount: post.reactionCountsByType[ReactionType.offside] ?? 0,
      ),
      commentsCount: post.commentsCount,
      location: post.location,
      flagged: post.flagged,
      groupID: post.groupID,
      groupName: post.groupName,
      groupCoverImage: post.groupCoverImage,
      reactionCountsByType: post.reactionCountsByType,
      createdAt: post.createdAt,
    );
  }
}
