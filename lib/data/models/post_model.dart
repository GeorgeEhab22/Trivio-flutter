import 'package:auth/common/functions/parse_date_correct.dart';
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
    super.tags = const [],
    super.shownTags = false,
    super.isAuthorFollowed = false,
    super.sharedFrom,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> raw = json['post'] is Map<String, dynamic>
        ? json['post']
        : (json['data']?['post'] is Map<String, dynamic>
            ? json['data']['post']
            : json);

    final bool isFollowed =
        json['isFollowed'] ??
        (json['data'] != null ? json['data']['isFollowed'] ?? false : false);

    final dummyReactions = _parseReactionCounter(raw['reactionCounts']);

    /// ✅ GROUP SAFE
    final dynamic groupData = raw['groupID'];
    String? gID;
    String? gName;
    String? gCover;

    if (groupData is String) {
      gID = groupData;
    } else if (groupData is Map<String, dynamic>) {
      gID = JsonParser.parseId(groupData['_id']);
      gName = JsonParser.parseString(groupData['name']);
      gCover = JsonParser.parseString(
        groupData['coverImage'] ?? groupData['logo'],
      );
    }

    /// ✅ AUTHOR SAFE (UPDATED 🔥)
    final dynamic authorData =
        raw['author_details'] ??
        raw['author'] ??
        raw['authorID'] ??
        raw['authorId'] ??
        raw['user'];

    String aId = '';
    String? aName;
    String? aImage;

    if (authorData != null) {
      // Case 1: ID only
      if (authorData is String) {
        aId = authorData;
      }
      // Case 2: full object
      else if (authorData is Map<String, dynamic>) {
        aId = JsonParser.parseId(authorData['_id']) ??
            authorData['id']?.toString() ??
            '';

        aName = JsonParser.parseString(
          authorData['username'] ??
              authorData['name'] ??
              authorData['fullName'],
        );

        aImage = JsonParser.parseString(
          authorData['avatar'] ??
              authorData['profilePicture'] ??
              authorData['image'],
        );
      }
    }

    /// ✅ USER REACTION SAFE
    final userReaction = JsonParser.parseReactionType(
      json['userReact']?.toString(),
    );

    /// ✅ MENTIONS SAFE
    final mentionsJson = raw['mentions'] as List<dynamic>? ?? [];
    final userIds = <String>[];
    final usernames = <String>[];

    for (final m in mentionsJson) {
      if (m is Map<String, dynamic>) {
        userIds.add(JsonParser.parseId(m['_id']) ?? '');
        usernames.add(JsonParser.parseString(m['username']));
      }
    }

    final mentions = Mentions(userIds: userIds, usernames: usernames);

    /// ✅ MEDIA SAFE
    final mediaList = (raw['media'] as List<dynamic>? ?? []).map((m) {
      if (m is Map<String, dynamic>) {
        return JsonParser.parseString(m['url']);
      }
      return JsonParser.parseString(m);
    }).where((url) => url.isNotEmpty).toList();

    /// ✅ SHARED POST SAFE
    final dynamic sharedData = raw['sharedFrom'];
    String? sID;

    if (sharedData is String) {
      sID = sharedData;
    } else if (sharedData is Map<String, dynamic>) {
      sID =
          JsonParser.parseId(sharedData['_id']) ??
          sharedData['id']?.toString();
    }

    return PostModel(
      postID: JsonParser.parseId(raw['_id']) ?? '',
      sharedFrom: sID,
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
      reactionCountsByType:
          JsonParser.mapReactionCounts(raw['reactionCounts']),

      reactionsCount: _calculateTotalReactions(raw, dummyReactions),
      userReaction: userReaction,

      commentsCount: JsonParser.parseInt(
        raw['commentsCount'] ??
            raw['comments_count'] ??
            raw['repliesCount'],
      ),

      createdAt: DateParser.parseDateCorrectly(raw['createdAt']),

      tags: (raw['tags'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),

      shownTags: raw['shownTags'] ?? false,
      isAuthorFollowed: isFollowed,
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
            {
              '_id': mentions!.userIds[i],
              'username': mentions!.usernames[i]
            },
      ],
      'media': media?.map((url) {
        final isVideo = url.toLowerCase().endsWith('.mp4') ||
            url.toLowerCase().endsWith('.mov') ||
            url.toLowerCase().endsWith('.webm');
        return {
          'url': url,
          'mediaType': isVideo ? 'reel' : 'image',
        };
      }).toList(),
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
      'tags': tags,
      'shownTags': shownTags,
    };
  }

  Post toEntity() {
    return Post(
      sharedFrom: sharedFrom,
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
      tags: tags,
      shownTags: shownTags,
      isAuthorFollowed: isAuthorFollowed,
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
            post.reactionCountsByType[ReactionType.like] ??
            post.reactionsCount,
        lovesCount: post.reactionCountsByType[ReactionType.love] ?? 0,
        hahaCount: post.reactionCountsByType[ReactionType.haha] ?? 0,
        sadCount: post.reactionCountsByType[ReactionType.sad] ?? 0,
        angryCount: post.reactionCountsByType[ReactionType.angry] ?? 0,
        wowCount: post.reactionCountsByType[ReactionType.wow] ?? 0,
        goalCount: post.reactionCountsByType[ReactionType.goal] ?? 0,
        offsideCount:
            post.reactionCountsByType[ReactionType.offside] ?? 0,
      ),
      commentsCount: post.commentsCount,
      location: post.location,
      flagged: post.flagged,
      groupID: post.groupID,
      groupName: post.groupName,
      groupCoverImage: post.groupCoverImage,
      reactionCountsByType: post.reactionCountsByType,
      createdAt: post.createdAt,
      tags: post.tags,
      shownTags: post.shownTags,
    );
  }
}