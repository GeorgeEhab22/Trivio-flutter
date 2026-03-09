import 'package:auth/core/json_parser.dart';
import 'package:auth/domain/entities/comment.dart';
import 'package:auth/domain/entities/reaction.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'reaction_model.dart';

class CommentModel extends Comment {
  const CommentModel({
    required super.id,
    required super.postId,
    required super.authorId,
    required super.authorName,
    super.authorImage,
    required super.text,
    required super.createdAt,
    super.editedAt,
    super.isEdited = false,
    super.reactions = const [],
    super.reactionsCount = 0,
    super.userReaction = ReactionType.none,
    super.reactionCountsByType = const <ReactionType, int>{},
    super.repliesCount = 0,
    super.parentCommentId,
  });
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> raw =
        (json['data'] != null && json['data']['comment'] != null)
        ? json['data']['comment'] as Map<String, dynamic>
        : json;

    final dynamic userData = raw['userId'] ?? raw['author'] ?? raw['user'];
    final dynamic postData = raw['postId'] ?? raw['post'];

    final userReaction = JsonParser.parseReactionType(
      raw['userReaction'] ?? raw['myReaction'] ?? raw['currentUserReaction'],
    );
    final reactionCounts = JsonParser.mapReactionCounts(raw['reactionCounts']);
    final reactionsList = _parseReactionsList(raw['reactions']);

    final authorId =
        JsonParser.parseId(userData) ?? (raw['authorId']?.toString() ?? '');
    final postId = JsonParser.parseId(postData) ?? '';

    // Safely parse dates
    final DateTime? createdAt = raw['createdAt'] != null
        ? DateTime.tryParse(raw['createdAt'].toString())
        : null;

    final DateTime? updatedAt = (raw['editedAt'] ?? raw['updatedAt']) != null
        ? DateTime.tryParse((raw['editedAt'] ?? raw['updatedAt']).toString())
        : null;

    bool serverIsEdited = false;
    if (raw['isEdited'] is bool) {
      serverIsEdited = raw['isEdited'];
    } else if (raw['isEdited'] is String) {
      serverIsEdited = raw['isEdited'].toLowerCase() == 'true';
    }
    

    return CommentModel(
      id: JsonParser.parseId(raw['_id'] ?? raw['id']) ?? '',
      postId: postId,
      authorId: authorId,
      authorName: _parseAuthorName(raw, userData),
      authorImage: _parseAuthorImage(raw, userData),
      text: raw['text']?.toString() ?? '',
      createdAt: createdAt ?? DateTime.now(),
      editedAt: updatedAt,
     isEdited: serverIsEdited ,
      reactions: reactionsList,
      userReaction: userReaction,
      reactionCountsByType: reactionCounts,
      reactionsCount: _calculateTotalReactions(
        raw,
        userReaction,
        reactionsList.length,
      ),
      repliesCount: JsonParser.parseInt(raw['repliesCount']),
      parentCommentId: JsonParser.parseId(
        raw['parentCommentId'] ?? raw['parentId'] ?? raw['parent'],
      ),
    );
  }

  static String _parseAuthorName(Map<String, dynamic> json, dynamic userData) {
    final name = json['authorName'] ?? json['userName'];
    if (name != null) return name.toString();
    if (userData is Map<String, dynamic>) {
      return (userData['username'] ?? userData['name'] ?? 'Unknown User')
          .toString();
    }
    return 'Unknown User';
  }

  static String? _parseAuthorImage(
    Map<String, dynamic> json,
    dynamic userData,
  ) {
    final img = json['authorImage'];
    if (img != null) return img.toString();
    if (userData is Map<String, dynamic>) {
      return (userData['profilePicture'] ??
              userData['profileImage'] ??
              userData['avatar'])
          ?.toString();
    }
    return null;
  }

  static List<Reaction> _parseReactionsList(dynamic list) {
    if (list is! List) return [];
    return list
        .whereType<Map<String, dynamic>>()
        .map((r) => ReactionModel.fromJson(r).toEntity())
        .toList();
  }

  static int _calculateTotalReactions(
    Map<String, dynamic> json,
    ReactionType userReaction,
    int listLength,
  ) {
    final count = JsonParser.parseInt(
      json['reactionsCount'] ?? json['reactions_count'],
    );
    if (count > 0) return count;
    if (userReaction != ReactionType.none) {
      return listLength > 0 ? listLength : 1;
    }
    return listLength;
  }

  Comment toEntity() => Comment(
    id: id,
    postId: postId,
    authorId: authorId,
    authorName: authorName,
    authorImage: authorImage,
    text: text,
    editedAt: editedAt,
    isEdited: isEdited,
    createdAt: createdAt,
    reactions: reactions,
    reactionsCount: reactionsCount,
    userReaction: userReaction,
    reactionCountsByType: reactionCountsByType,
    repliesCount: repliesCount,
    parentCommentId: parentCommentId,
  );

  factory CommentModel.fromEntity(Comment comment) {
    return CommentModel(
      id: comment.id,
      postId: comment.postId,
      authorId: comment.authorId,
      authorName: comment.authorName,
      authorImage: comment.authorImage,
      text: comment.text,
      createdAt: comment.createdAt,
      editedAt: comment.editedAt,
      isEdited: comment.isEdited,
      reactions: comment.reactions,
      reactionsCount: comment.reactionsCount,
      userReaction: comment.userReaction,
      reactionCountsByType: comment.reactionCountsByType,
      repliesCount: comment.repliesCount,
      parentCommentId: comment.parentCommentId,
    );
  }

  factory CommentModel.empty() {
    return CommentModel(
      id: '',
      postId: '',
      authorId: '',
      authorName: '',
      authorImage: null,
      text: '',
      createdAt: DateTime.now(),
      editedAt: null,
      isEdited: false,
      reactions: const [],
      reactionsCount: 0,
      userReaction: ReactionType.none,
      repliesCount: 0,
      parentCommentId: null,
    );
  }
}
