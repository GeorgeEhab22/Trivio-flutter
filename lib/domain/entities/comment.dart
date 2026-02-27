import 'package:auth/domain/entities/comment_history.dart';
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
  final int repliesCount;
  final String? parentCommentId;
  final List<Comment>? repliesList;
  final List<CommentRevision>? history;
  final bool isEdited;

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
    this.repliesCount = 0,
    this.parentCommentId,
    this.repliesList = const [],
    this.history,
    this.isEdited = false,
  });

  Comment copyWith({
    String? id,
    String? postId,
    String? authorId,
    String? authorName,
    String? authorImage,
    String? text,
    DateTime? createdAt,
    DateTime? editedAt,
    List<Reaction>? reactions,
    int? repliesCount,
    String? parentCommentId,
    List<Comment>? repliesList,
    List<CommentRevision>? history,
      bool? isEdited,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorImage: authorImage ?? this.authorImage,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      editedAt: editedAt ?? this.editedAt,
      reactions: reactions ?? this.reactions,
      repliesCount: repliesCount ?? this.repliesCount,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      repliesList: repliesList ?? this.repliesList,
      history: history ?? this.history,
      isEdited: isEdited ?? this.isEdited,
    );
  }

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
        editedAt,
        reactions,
        repliesCount,
        parentCommentId,
        repliesList,
        history,
      ];
}