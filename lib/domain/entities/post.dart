import 'package:auth/domain/entities/reaction.dart';
import 'package:auth/domain/entities/comment.dart';
import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorImage;
  final String content;
  final String? imageUrl;
  final String? videoUrl;
  final DateTime createdAt;
  final DateTime? editedAt;
  final List<Comment> comments;
  final List<Reaction> reactions;

  const Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorImage,
    required this.content,
    this.imageUrl,
    this.videoUrl,
    required this.createdAt,
    this.editedAt,
    this.comments = const [],
    this.reactions = const [],
  });

  int get likesCount => reactions.length;
  int get commentsCount => comments.length;

  @override
  List<Object?> get props => [
    id,
    authorId,
    authorName,
    authorImage,
    content,
    imageUrl,
    createdAt,
    editedAt,
    comments,
    reactions,
  ];
}
