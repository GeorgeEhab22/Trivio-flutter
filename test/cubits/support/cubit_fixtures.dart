// import 'package:auth/core/errors/failure.dart';
// import 'package:auth/domain/entities/comment.dart';
// import 'package:auth/domain/entities/post.dart';
// import 'package:auth/domain/entities/reaction.dart';
// import 'package:auth/domain/entities/reaction_type.dart';

// const String kId1 = '507f1f77bcf86cd799439011';
// const String kId2 = '507f1f77bcf86cd799439012';
// const String kId3 = '507f1f77bcf86cd799439013';
// const String kUser1 = '507f1f77bcf86cd799439021';
// const String kUser2 = '507f1f77bcf86cd799439022';

// Post makePost({
//   String id = kId1,
//   String caption = 'caption',
//   int commentsCount = 0,
//   int reactionsCount = 0,
//   ReactionType reaction = ReactionType.none,
//   List<Reaction>? reactions,
// }) {
//   return Post(
//     postID: id,
//     type: 'text',
//     caption: caption,
//     commentsCount: commentsCount,
//     reactionsCount: reactionsCount,
//     userReaction: reaction,
//     reactions: reactions,
//   );
// }

// Comment makeComment({
//   String id = kId1,
//   String postId = kId2,
//   String authorId = kUser1,
//   String authorName = 'user',
//   String text = 'text',
//   int reactionsCount = 0,
//   int repliesCount = 0,
//   ReactionType reaction = ReactionType.none,
//   List<Reaction> reactions = const <Reaction>[],
//   String? parentCommentId,
// }) {
//   return Comment(
//     id: id,
//     postId: postId,
//     authorId: authorId,
//     authorName: authorName,
//     text: text,
//     createdAt: DateTime(2024, 1, 1),
//     reactionsCount: reactionsCount,
//     repliesCount: repliesCount,
//     userReaction: reaction,
//     reactions: reactions,
//     parentCommentId: parentCommentId,
//   );
// }

// Reaction makeReaction({
//   String id = kId3,
//   String userId = kUser1,
//   String postId = kId2,
//   ReactionType type = ReactionType.like,
// }) {
//   return Reaction(id: id, userId: userId, postId: postId, type: type);
// }

// Failure serverFail([String m = 'server']) => ServerFailure(m);
// Failure networkFail([String m = 'network']) => NetworkFailure(m);
// Failure validationFail([String m = 'validation']) => ValidationFailure(m);
