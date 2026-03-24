// import 'package:auth/domain/entities/comment.dart';
// import 'package:auth/domain/entities/post.dart';
// import 'package:auth/domain/entities/reaction_type.dart';
// import 'package:auth/presentation/manager/comment_cubit/comment_state.dart';
// import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';

// Post samplePost({
//   String id = '507f1f77bcf86cd799439011',
//   String caption = 'Sample post',
// }) {
//   return Post(
//     postID: id,
//     type: 'text',
//     caption: caption,
//     commentsCount: 0,
//     reactionsCount: 0,
//     userReaction: ReactionType.none,
//   );
// }

// Comment sampleComment({
//   String id = '507f1f77bcf86cd799439021',
//   String postId = '507f1f77bcf86cd799439011',
// }) {
//   return Comment(
//     id: id,
//     postId: postId,
//     authorId: '507f1f77bcf86cd799439031',
//     authorName: 'tester',
//     text: 'Sample comment',
//     createdAt: DateTime(2024, 1, 1),
//   );
// }

// class PostStateBuilder {
//   const PostStateBuilder();

//   PostLoaded loaded({List<Post>? posts, bool hasReachedMax = false}) {
//     return PostLoaded(
//       posts ?? <Post>[samplePost()],
//       hasReachedMax: hasReachedMax,
//     );
//   }

//   PostError error([String message = 'Post load failed']) => PostError(message);
// }

// class CommentStateBuilder {
//   const CommentStateBuilder();

//   CommentLoaded loaded({List<Comment>? comments, bool isRefetching = false}) {
//     return CommentLoaded(
//       comments ?? <Comment>[sampleComment()],
//       isRefetching: isRefetching,
//     );
//   }

//   CommentError error([String message = 'Comment load failed']) =>
//       CommentError(message);
// }
