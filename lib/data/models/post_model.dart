import 'dart:core';

import 'package:auth/data/models/reaction_model.dart';
import 'package:auth/domain/entities/mentions.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/reaction.dart';
import 'package:auth/domain/entities/reaction_type.dart';

class PostModel extends Post {
  final int updateCount; // maps "__v"
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
    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    ReactionType parseReactionType(dynamic rawType) {
      final value = (rawType ?? '').toString().trim().toLowerCase();
      if (value.isEmpty) {
        return ReactionType.none;
      }
      try {
        return ReactionType.values.firstWhere((type) => type.name == value);
      } catch (_) {
        return ReactionType.none;
      }
    }

    final Map<String, dynamic> raw =
        (json['data'] != null && json['data']['post'] != null)
        ? json['data']['post'] as Map<String, dynamic>
        : json;

    final dynamic groupData = raw['groupID'];
    String? gID;
    String? gName;
    String? gCover;

    if (groupData is String) {
      gID = groupData;
    } else if (groupData is Map<String, dynamic>) {
      gID = (groupData['_id'] ?? '').toString();
      gName = groupData['name']?.toString();
      gCover = (groupData['coverImage'] ?? groupData['logo'])?.toString();
    }

    final Map<String, dynamic> reactionMap =
        (raw['reactionCounts'] as Map<String, dynamic>? ?? <String, dynamic>{});

    final dummyReactions = DummyReactionCounter(
      likesCount: parseInt(reactionMap['like']),
      lovesCount: parseInt(reactionMap['love']),
      hahaCount: parseInt(reactionMap['haha']),
      sadCount: parseInt(reactionMap['sad']),
      angryCount: parseInt(reactionMap['angry']),
      wowCount: parseInt(reactionMap['wow']),
      goalCount: parseInt(reactionMap['goal']),
      offsideCount: parseInt(reactionMap['offside']),
    );
    final reactionCountsByType = <ReactionType, int>{
      ReactionType.like: dummyReactions.likesCount,
      ReactionType.love: dummyReactions.lovesCount,
      ReactionType.haha: dummyReactions.hahaCount,
      ReactionType.wow: dummyReactions.wowCount,
      ReactionType.sad: dummyReactions.sadCount,
      ReactionType.angry: dummyReactions.angryCount,
      ReactionType.goal: dummyReactions.goalCount,
      ReactionType.offside: dummyReactions.offsideCount,
    }..removeWhere((_, count) => count <= 0);

    final reactionsJson = raw['reactions'];
    final List<Reaction> reactions = reactionsJson is List
        ? reactionsJson
              .whereType<Map<String, dynamic>>()
              .map((item) => ReactionModel.fromJson(item).toEntity())
              .toList()
        : const <Reaction>[];

    var totalReactionsCount = parseInt(
      raw['reactionsCount'] ?? raw['reactions_count'],
    );
    if (totalReactionsCount == 0) {
      totalReactionsCount = dummyReactions.total;
    }
    if (totalReactionsCount == 0 && reactions.isNotEmpty) {
      totalReactionsCount = reactions.length;
    }

    final userReaction = parseReactionType(
      raw['userReaction'] ?? raw['myReaction'] ?? raw['currentUserReaction'],
    );
    if (userReaction != ReactionType.none && totalReactionsCount == 0) {
      totalReactionsCount = 1;
    }

    final mentionsJson = raw['mentions'] as List<dynamic>? ?? [];
    final userIds = <String>[];
    final usernames = <String>[];

    for (final m in mentionsJson) {
      final map = m as Map<String, dynamic>;
      userIds.add((map['_id'] ?? '').toString());
      usernames.add((map['username'] ?? '').toString());
    }

    final mentions = Mentions(userIds: userIds, usernames: usernames);

    final mediaList = (raw['media'] as List<dynamic>? ?? [])
        .map((m) => m.toString())
        .toList();
    final commentsList = (raw['comments'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .toList();

    var topLevelCommentsCount = parseInt(
      raw['commentsCount'] ?? raw['comments_count'],
    );
    if (topLevelCommentsCount == 0 && commentsList.isNotEmpty) {
      topLevelCommentsCount = commentsList.length;
    }

    var repliesCount = parseInt(
      raw['totalRepliesCount'] ?? raw['repliesCount'] ?? raw['replies_count'],
    );
    if (repliesCount == 0 && commentsList.isNotEmpty) {
      repliesCount = commentsList.fold<int>(
        0,
        (sum, comment) => sum + parseInt(comment['repliesCount']),
      );
    }

    final totalCommentsWithReplies = topLevelCommentsCount + repliesCount;

    return PostModel(
      postID: (raw['_id'] ?? '').toString(),
      updateCount: parseInt(raw['__v']),
      authorId: (raw['authorID'] ?? raw['authorId'] ?? '').toString(),
      type: (raw['type'] ?? 'public').toString(),
      caption: raw['caption']?.toString(),
      location: raw['location']?.toString(),
      mentions: mentions,
      media: mediaList,
      views: parseInt(raw['views']),
      flagged: (raw['flagged'] ?? false) as bool,
      reactionCounts: dummyReactions,
      reactions: reactions,
      reactionsCount: totalReactionsCount,
      userReaction: userReaction,
      groupID: gID,
      groupName: gName,
      groupCoverImage: gCover,
      commentsCount: totalCommentsWithReplies,
      reactionCountsByType: reactionCountsByType,
    );
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
      reactionCountsByType: reactionCountsByType,
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
    );
  }
}
