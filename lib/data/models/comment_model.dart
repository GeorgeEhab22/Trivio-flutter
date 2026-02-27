import 'package:auth/domain/entities/comment.dart';
import 'package:auth/domain/entities/reaction.dart';
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
    super.reactions = const [],
    super.repliesCount = 0,
    super.parentCommentId,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    String? normalizeId(String value) {
      final parsed = value.trim();
      if (parsed.isEmpty) {
        return null;
      }
      final lowered = parsed.toLowerCase();
      if (lowered == 'null' || lowered == 'undefined') {
        return null;
      }
      return parsed;
    }

    String? parseId(dynamic value) {
      if (value == null) {
        return null;
      }
      if (value is Map<String, dynamic>) {
        final nested =
            value['_id'] ??
            value['id'] ??
            value[r'$oid'] ??
            value['oid'] ??
            value['value'];
        return parseId(nested);
      }
      if (value is String) {
        return normalizeId(value);
      }
      return normalizeId(value.toString());
    }

    DateTime parseDate(dynamic value, DateTime fallback) {
      if (value == null) {
        return fallback;
      }
      return DateTime.tryParse(value.toString()) ?? fallback;
    }

    final dynamic userData = json['userId'] ?? json['author'] ?? json['user'];
    final dynamic postData = json['postId'] ?? json['post'];

    final String authorId = userData is Map<String, dynamic>
        ? (userData['_id'] ?? userData['id'] ?? '').toString()
        : (json['authorId'] ?? userData ?? '').toString();

    final String postId = postData is Map<String, dynamic>
        ? (postData['_id'] ?? postData['id'] ?? '').toString()
        : (postData ?? '').toString();

    final String authorName =
        (json['authorName'] ??
                json['userName'] ??
                (userData is Map<String, dynamic>
                    ? (userData['username'] ?? userData['name'])
                    : null) ??
                'Unknown User')
            .toString();

    final String? authorImage =
        (json['authorImage'] ??
                (userData is Map<String, dynamic>
                    ? (userData['profileImage'] ??
                          userData['profilePicture'] ??
                          userData['avatar'])
                    : null))
            ?.toString();

    final DateTime createdAt = parseDate(json['createdAt'], DateTime.now());
    DateTime? editedAt;
    if (json['editedAt'] != null) {
      editedAt = DateTime.tryParse(json['editedAt'].toString());
    } else if (json['isEdited'] == true && json['updatedAt'] != null) {
      editedAt = DateTime.tryParse(json['updatedAt'].toString());
    }

    final dynamic reactionsJson = json['reactions'];
    final List<Reaction> reactions = reactionsJson is List
        ? reactionsJson
              .whereType<Map<String, dynamic>>()
              .map((r) => ReactionModel.fromJson(r).toEntity())
              .toList()
        : <Reaction>[];

    final dynamic parentRaw =
        json['parentCommentId'] ??
        json['parentId'] ??
        json['parent'] ??
        json['parentComment'];
    final String? parsedParentId = parseId(parentRaw);

    return CommentModel(
      id: parseId(json['_id'] ?? json['id']) ?? '',
      postId: postId,
      authorId: authorId,
      authorName: authorName,
      authorImage: authorImage,
      text: (json['text'] ?? '').toString(),
      createdAt: createdAt,
      editedAt: editedAt,
      reactions: reactions,
      repliesCount: parseInt(json['repliesCount']),
      parentCommentId: parsedParentId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'postId': postId,
      'authorId': authorId,
      'authorName': authorName,
      'authorImage': authorImage,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'editedAt': editedAt?.toIso8601String(),
      'reactions': reactions
          .map((r) => ReactionModel.fromEntity(r).toJson())
          .toList(),
      'repliesCount': repliesCount,
      'parentCommentId': parentCommentId,
    };
  }

  Comment toEntity() => Comment(
    id: id,
    postId: postId,
    authorId: authorId,
    authorName: authorName,
    authorImage: authorImage,
    text: text,
    editedAt: editedAt,
    createdAt: createdAt,
    reactions: reactions,
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
      reactions: comment.reactions,
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
      reactions: const [],
      repliesCount: 0,
      parentCommentId: null,
    );
  }
}

int parseInt(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
