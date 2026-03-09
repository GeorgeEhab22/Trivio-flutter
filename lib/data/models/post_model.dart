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
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> raw =
        (json['data'] != null && json['data']['post'] != null)
            ? json['data']['post'] as Map<String, dynamic>
            : json;

    final dummyReactions = _parseReactionCounter(raw['reactionCounts']);

    final userReaction = JsonParser.parseReactionType(
      raw['userReaction'] ?? raw['myReaction'] ?? raw['currentUserReaction'],
    );

    return PostModel(
      postID: JsonParser.parseString(raw['_id']),
      updateCount: JsonParser.parseInt(raw['__v']),
      authorId: JsonParser.parseString(raw['authorID'] ?? raw['authorId']),
      type: JsonParser.parseString(raw['type'], fallback: 'public'),
      caption: JsonParser.parseString(raw['caption']),
      location: JsonParser.parseString(raw['location']),
      views: JsonParser.parseInt(raw['views']),
      flagged: raw['flagged'],
      media: JsonParser.parseStringList(raw['media']),
      mentions: _parseMentions(raw['mentions']),

      // Group Data Handling
      groupID: _parseGroupData(raw['groupID'], 'id'),
      groupName: _parseGroupData(raw['groupID'], 'name'),
      groupCoverImage: _parseGroupData(raw['groupID'], 'cover'),

      reactions: _parseReactions(raw['reactions']),
      reactionCounts: dummyReactions,
      reactionCountsByType: JsonParser.mapReactionCounts(raw['reactionCounts']),

      reactionsCount: _calculateTotalReactions(raw, dummyReactions),
      userReaction: userReaction,
      //TODO: Handle commentsCount properly 
      commentsCount: JsonParser.parseInt(
        raw['commentsCount'] ?? raw['comments_count'] ?? raw['repliesCount'],
      ),
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

  static Mentions _parseMentions(dynamic list) {
    final items = list is List
        ? list.whereType<Map<String, dynamic>>()
        : <Map<String, dynamic>>[];
    return Mentions(
      userIds: items.map((m) => JsonParser.parseString(m['_id'])).toList(),
      usernames: items
          .map((m) => JsonParser.parseString(m['username']))
          .toList(),
    );
  }

  static String? _parseGroupData(dynamic data, String key) {
    if (data is Map<String, dynamic>) {
      if (key == 'id') return JsonParser.parseString(data['_id']);
      if (key == 'name') return JsonParser.parseString(data['name']);
      if (key == 'cover') {
        return JsonParser.parseString(data['coverImage'] ?? data['logo']);
      }
    }
    return data is String && key == 'id' ? data : null;
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
    final count = JsonParser.parseInt(raw['reactionsCount'] );
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
      'commentsCount': commentsCount,
    };
  }

  Post toEntity() {
    return Post(
      authorId: authorId,
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
      reactionCountsByType: JsonParser.mapReactionCounts(toJson()['reactionCounts']),
    );
  }

  factory PostModel.fromEntity(Post post) {
    return PostModel(
      postID: post.postID,
      updateCount: 0,
      authorId: post.authorId,
      type: post.type,
      caption: post.caption,
      mentions: post.mentions,
      media: post.media ?? const [],
      reactions: post.reactions ?? const [],
      reactionsCount: post.reactionsCount,
      userReaction: post.userReaction,
      reactionCounts: DummyReactionCounter(
        likesCount: post.reactionCountsByType[ReactionType.like] ?? post.reactionsCount,
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
    );
  }
}