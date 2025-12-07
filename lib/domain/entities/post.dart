import 'package:auth/domain/entities/mentions.dart';
import 'package:auth/domain/entities/reaction.dart';
import 'package:equatable/equatable.dart';

// TODO : write the acual class after finish the backend in all entities.. filse..
class Post extends Equatable {
  final String? authorId;
  final String? postID;
  final String? caption;
  final String type;
  final Mentions ? mentions; 
  final bool? flagged;
  final List<Reaction>? reactions;
  final List <String> ? media;


  const Post({
    this.authorId,
    required this.type,
    this.postID,
    this.caption,
    this.flagged,
    this.mentions,
    this.reactions,
    this.media,
  });

  int get likesCount => reactions?.length ?? 0;
  //int get commentsCount => comments.length;

  @override
  List<Object?> get props => [
    authorId,
    caption,
    type,
    mentions,
  ];
}
