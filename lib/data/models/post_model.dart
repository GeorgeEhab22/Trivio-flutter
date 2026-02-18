import 'dart:core';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/mentions.dart';
import 'package:auth/domain/entities/reaction_type.dart';

class PostModel extends Post {
  final int updateCount; // maps "__v"
  @override
  final List<String> media; // server media URLs / filenames
  final int views;
  final DummyReactionCounter reactionCounts;

  const PostModel({
    required super.postID,
    required this.updateCount,
    required this.reactionCounts,
    required this.media,
    required super.authorId, // from Post entity
    required super.type, // from Post entity
    super.caption,
    super.location,
    super.mentions,
    this.views = 0,
    super.flagged,
    super.groupID,
    super.groupName,
    super.groupCoverImage,
  });

  /// Accepts either the whole response or just the `post` map.
  factory PostModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> raw =
        (json['data'] != null && json['data']['post'] != null)
        ? json['data']['post'] as Map<String, dynamic>
        : json;
//  get group id as object that contain name and id and cover
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
    // --- reactionCounts ---
    final Map<String, dynamic> reactionMap =
        raw['reactionCounts'] as Map<String, dynamic>? ?? {};

    final dummyReactions = DummyReactionCounter(
      likesCount: (reactionMap['like'] ?? 0) as int,
      lovesCount: (reactionMap['love'] ?? 0) as int,
      hahaCount: (reactionMap['haha'] ?? 0) as int,
      sadCount: (reactionMap['sad'] ?? 0) as int,
      angryCount: (reactionMap['angry'] ?? 0) as int,
      wowCount: (reactionMap['wow'] ?? 0) as int,
    );

    // --- mentions ---
    final mentionsJson = raw['mentions'] as List<dynamic>? ?? [];
    final userIds = <String>[];
    final usernames = <String>[];

    for (final m in mentionsJson) {
      final map = m as Map<String, dynamic>;
      userIds.add(map['_id'] as String? ?? '');
      usernames.add(map['username'] as String? ?? '');
    }

    final mentions = Mentions(userIds: userIds, usernames: usernames);

    // --- media (list of URLs / filenames coming from backend) ---
    final mediaList = (raw['media'] as List<dynamic>? ?? [])
        .map((m) => m as String)
        .toList();

    return PostModel(
      postID: raw['_id'] as String? ?? '',
      updateCount: (raw['__v'] ?? 0) as int,
      authorId: raw['authorID'] as String? ?? '',
      type: raw['type'] as String? ?? 'public',
      caption: raw['caption'] as String?,
      location: raw['location'] as String?,
      mentions: mentions,
      media: mediaList,
      views: (raw['views'] ?? 0) as int,
      flagged: (raw['flagged'] ?? false) as bool,
      reactionCounts: dummyReactions,
      groupID: gID,
      groupName: gName,
      groupCoverImage: gCover,
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
      },
      'groupID': groupID,
      'groupName': groupName,
      'groupCoverImage': groupCoverImage,
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
      postID: postID,
      groupID: groupID,
      groupName: groupName,
      groupCoverImage: groupCoverImage,
    );
  }

  factory PostModel.fromEntity(Post post) {
    return PostModel(
      postID: '',
      updateCount: 0,
      authorId: post.authorId,
      type: post.type,
      caption: post.caption,
      mentions: post.mentions,
      media: const [],
      reactionCounts: DummyReactionCounter(
        likesCount: 0,
        lovesCount: 0,
        hahaCount: 0,
        sadCount: 0,
        angryCount: 0,
        wowCount: 0,
      ),
    );
  }
}
