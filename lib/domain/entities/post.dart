import 'package:auth/domain/entities/mentions.dart';
import 'package:auth/domain/entities/reaction.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String? authorId;
  final String? postID;
  final String? caption;
  final String type;
  final Mentions? mentions;
  final bool? flagged;
  final List<Reaction>? reactions;
  final List<String>? media;
  final String? location;
  final String? groupID;
  final String? groupName;
  final String? groupCoverImage;
  final int commentsCount;
  final int reactionsCount;
  final ReactionType userReaction;

  const Post({
    this.authorId,
    required this.type,
    this.postID,
    this.caption,
    this.flagged,
    this.mentions,
    this.reactions,
    this.media,
    this.location,
    this.groupID,
    this.groupName,
    this.groupCoverImage,
    this.commentsCount = 0,
    this.reactionsCount = 0,
    this.userReaction = ReactionType.none,
  });
  Post copyWith({
    String? authorId,
    String? postID,
    String? caption,
    String? type,
    Mentions? mentions,
    bool? flagged,
    List<Reaction>? reactions,
    List<String>? media,
    String? location,
    String? groupID,
    String? groupName,
    String? groupCoverImage,
    int? commentsCount,
    int? reactionsCount,
    ReactionType? userReaction,
  }) {
    return Post(
      authorId: authorId ?? this.authorId,
      postID: postID ?? this.postID,
      caption: caption ?? this.caption,
      type: type ?? this.type,
      mentions: mentions ?? this.mentions,
      flagged: flagged ?? this.flagged,
      reactions: reactions ?? this.reactions,
      media: media ?? this.media,
      location: location ?? this.location,
      groupID: groupID ?? this.groupID,
      groupName: groupName ?? this.groupName,
      groupCoverImage: groupCoverImage ?? this.groupCoverImage,
      commentsCount: commentsCount ?? this.commentsCount,
      reactionsCount: reactionsCount ?? this.reactionsCount,
      userReaction: userReaction ?? this.userReaction,
    );
  }

  int get likesCount => reactionsCount;
  //int get commentsCount => comments.length;

  @override
  List<Object?> get props => [
    authorId,
    caption,
    type,
    mentions,
    location,
    groupID,
    commentsCount,
    reactionsCount,
    userReaction,
  ];
}
