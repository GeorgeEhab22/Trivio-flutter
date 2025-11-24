import 'package:auth/domain/entities/comment.dart';
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
    super.parentCommentId,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['_id'] ?? '',
      postId: json['postId'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      authorImage: json['authorImage'],
      text: json['text'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      editedAt: json['editedAt'] != null
          ? DateTime.parse(json['editedAt'])
          : null,
      reactions: (json['reactions'] as List? ?? [])
          .map((r) => ReactionModel.fromJson(r).toEntity())
          .toList(),
      parentCommentId: json['parentCommentId'],
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
      parentCommentId: null,
    );
  }
}
