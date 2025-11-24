import 'package:auth/data/models/comment_model.dart';
import 'package:auth/data/models/reaction_model.dart';
import 'package:auth/domain/entities/post.dart';

class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.authorId,
    required super.authorName,
    super.authorImage,
    required super.content,
    super.imageUrl,
    super.videoUrl,
    required super.createdAt,
    super.editedAt,
    super.comments = const [],
    super.reactions = const [],
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['_id'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      authorImage: json['authorImage'],
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      editedAt: json['editedAt'] != null
          ? DateTime.parse(json['editedAt'])
          : null,
      comments: (json['comments'] as List<dynamic>? ?? [])
          .map((c) => CommentModel.fromJson(c).toEntity())
          .toList(),
      reactions: (json['reactions'] as List<dynamic>? ?? [])
          .map((r) => ReactionModel.fromJson(r).toEntity())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorImage': authorImage,
      'content': content,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'createdAt': createdAt.toIso8601String(),
      'editedAt': editedAt?.toIso8601String(),
      'comments': comments
          .map((c) => CommentModel.fromEntity(c).toJson())
          .toList(),
      'reactions': reactions
          .map((r) => ReactionModel.fromEntity(r).toJson())
          .toList(),
    };
  }

  Post toEntity() {
    return Post(
      id: id,
      authorId: authorId,
      authorName: authorName,
      authorImage: authorImage,
      content: content,
      imageUrl: imageUrl,
      videoUrl: videoUrl,
      createdAt: createdAt,
      editedAt: editedAt,
      comments: comments,
      reactions: reactions,
    );
  }

  factory PostModel.fromEntity(Post post) {
    return PostModel(
      id: post.id,
      authorId: post.authorId,
      authorName: post.authorName,
      authorImage: post.authorImage,
      content: post.content,
      imageUrl: post.imageUrl,
      videoUrl: post.videoUrl,
      createdAt: post.createdAt,
      editedAt: post.editedAt,
      comments: post.comments,
      reactions: post.reactions,
    );
  }

  factory PostModel.empty() {
    return PostModel(
      id: '',
      authorId: '',
      authorName: '',
      content: '',
      createdAt: DateTime.now(),
      editedAt: null,
      comments: const [],
      reactions: const [],
    );
  }
}
