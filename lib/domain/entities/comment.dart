import 'package:auth/domain/entities/reaction.dart';
import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String id;
  final String postId;
  final String authorId;
  final String authorName;
  final String? authorImage;
  final String text;
  final DateTime createdAt;
  final DateTime? editedAt;
  final List<Reaction> reactions;
  final String? parentCommentId;

  const Comment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.authorName,
    this.authorImage,
    required this.text,
    required this.createdAt,
    this.editedAt,
    this.reactions = const [],
    this.parentCommentId,
  });

  bool get isReply => parentCommentId != null;
  int get likesCount => reactions.length;

  @override
  List<Object?> get props => [
        id,
        postId,
        authorId,
        authorName,
        authorImage,
        text,
        createdAt,
        reactions,
        parentCommentId,
      ];
}
