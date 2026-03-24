// import 'package:auth/domain/entities/comment.dart';
// import 'package:auth/domain/entities/reaction.dart';
// import 'package:auth/domain/entities/reaction_type.dart';
// import 'package:auth/presentation/manager/comment_cubit/comment_cubit.dart';
// import 'package:auth/presentation/manager/comment_cubit/comment_state.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';

// import 'non_follow_cubits_test.dart';
// import 'support/cubit_fixtures.dart';

// Future<List<dynamic>> _captureStates(
//   Stream<dynamic> stream,
//   Future<void> Function() act, {
//   Duration settle = const Duration(milliseconds: 30),
// }) async {
//   final values = <dynamic>[];
//   final sub = stream.listen(values.add);
//   await act();
//   if (settle > Duration.zero) {
//     await Future<void>.delayed(settle);
//   }
//   await sub.cancel();
//   return values;
// }

// CommentCubit _buildCubit({
//   MockGetCommentsUseCase? getComments,
//   MockGetCommentUseCase? getComment,
//   MockGetCommentReactionsUseCase? getCommentReactions,
//   MockAddCommentUseCase? addComment,
//   MockDeleteCommentUseCase? deleteComment,
//   MockEditCommentUseCase? editComment,
//   MockGetRepliesUseCase? getReplies,
//   MockMentionUsersInCommentUseCase? mentionUsers,
//   MockReactToCommentUseCase? reactToComment,
//   MockRemoveReactionFromCommentUseCase? removeReaction,
// }) {
//   final effectiveGetReplies = getReplies ?? MockGetRepliesUseCase();
//   if (getReplies == null) {
//     when(
//       () => effectiveGetReplies(
//         any(),
//         page: any(named: 'page'),
//         limit: any(named: 'limit'),
//         sort: any(named: 'sort'),
//         fields: any(named: 'fields'),
//         keyword: any(named: 'keyword'),
//       ),
//     ).thenAnswer((_) async => const Right(<Comment>[]));
//   }

//   final effectiveGetCommentReactions =
//       getCommentReactions ?? MockGetCommentReactionsUseCase();
//   if (getCommentReactions == null) {
//     when(() => effectiveGetCommentReactions(commentId: any(named: 'commentId')))
//         .thenAnswer((_) async => const Right(<Reaction>[]));
//   }

//   return CommentCubit(
//     getCommentsUseCase: getComments ?? MockGetCommentsUseCase(),
//     getCommentUseCase: getComment ?? MockGetCommentUseCase(),
//     getCommentReactionsUseCase: effectiveGetCommentReactions,
//     addCommentUseCase: addComment ?? MockAddCommentUseCase(),
//     deleteCommentUseCase: deleteComment ?? MockDeleteCommentUseCase(),
//     editCommentUseCase: editComment ?? MockEditCommentUseCase(),
//     getRepliesUseCase: effectiveGetReplies,
//     mentionUsersInCommentUseCase: mentionUsers ?? MockMentionUsersInCommentUseCase(),
//     reactToCommentUseCase: reactToComment ?? MockReactToCommentUseCase(),
//     removeReactionFromCommentUseCase: removeReaction ?? MockRemoveReactionFromCommentUseCase(),
//   );
// }

// void main() {
//   group('CommentCubit deep behavior', () {
//     test(
//       'Unit Test - CommentCubit resets reply/edit markers when refetching comments',
//       () async {
//         final getComments = MockGetCommentsUseCase();
//         when(
//           () => getComments(
//             any(),
//             page: any(named: 'page'),
//             limit: any(named: 'limit'),
//             sort: any(named: 'sort'),
//             fields: any(named: 'fields'),
//             keyword: any(named: 'keyword'),
//           ),
//         ).thenAnswer((_) async => Right(<Comment>[makeComment(id: kId1)]));
//         final cubit = _buildCubit(getComments: getComments);

//         cubit.triggerReply(makeComment(id: kId2));
//         cubit.triggerEdit(makeComment(id: kId3));
//         await cubit.getComments(kId1);
//         await Future<void>.delayed(const Duration(milliseconds: 40));

//         expect(cubit.replyingTo, isNull);
//         expect(cubit.editingComment, isNull);
//         expect(cubit.state.runtimeType.toString(), 'CommentLoaded');
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - CommentCubit emits CommentActionError when replies fetch fails',
//       () async {
//         final getReplies = MockGetRepliesUseCase();
//         when(
//           () => getReplies(
//             any(),
//             page: any(named: 'page'),
//             limit: any(named: 'limit'),
//             sort: any(named: 'sort'),
//             fields: any(named: 'fields'),
//             keyword: any(named: 'keyword'),
//           ),
//         ).thenAnswer((_) async => Left(serverFail('load_failed')));
//         final cubit = _buildCubit(getReplies: getReplies);

//         final states = await _captureStates(
//           cubit.stream,
//           () => cubit.getRepliesForComment(kId1),
//         );

//         expect(states.last.runtimeType.toString(), 'CommentActionError');
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - CommentCubit addOrUpdateComment adds new comment and emits success action',
//       () async {
//         final addComment = MockAddCommentUseCase();
//         when(
//           () => addComment(
//             postId: any(named: 'postId'),
//             text: any(named: 'text'),
//             parentCommentId: any(named: 'parentCommentId'),
//           ),
//         ).thenAnswer((_) async => Right(makeComment(id: kId3, postId: kId1)));
//         final cubit = _buildCubit(addComment: addComment);
//         final states = await _captureStates(
//           cubit.stream,
//           () => cubit.addOrUpdateComment(kId1, 'new comment'),
//         );

//         expect(states.map((s) => s.runtimeType.toString()), contains('CommentLoaded'));
//         expect(states.last.runtimeType.toString(), 'CommentActionSuccess');
//         expect((states.last as CommentActionSuccess).message, 'added');
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - CommentCubit addOrUpdateComment edits selected comment and clears edit mode',
//       () async {
//         final getComments = MockGetCommentsUseCase();
//         final editComment = MockEditCommentUseCase();
//         final initial = makeComment(id: kId1, text: 'old');
//         final updated = makeComment(id: kId1, text: 'new');
//         when(
//           () => getComments(
//             any(),
//             page: any(named: 'page'),
//             limit: any(named: 'limit'),
//             sort: any(named: 'sort'),
//             fields: any(named: 'fields'),
//             keyword: any(named: 'keyword'),
//           ),
//         ).thenAnswer((_) async => Right(<Comment>[initial]));
//         when(
//           () => editComment(commentId: any(named: 'commentId'), newContent: any(named: 'newContent')),
//         ).thenAnswer((_) async => Right(updated));
//         final cubit = _buildCubit(getComments: getComments, editComment: editComment);
//         await cubit.getComments(kId2);
//         cubit.triggerEdit(initial);

//         final states = await _captureStates(
//           cubit.stream,
//           () => cubit.addOrUpdateComment(kId2, 'new'),
//         );

//         expect(states.last.runtimeType.toString(), 'CommentActionSuccess');
//         expect((states.last as CommentActionSuccess).message, 'updated');
//         expect(cubit.editingComment, isNull);
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - CommentCubit deleteComment removes comment and emits deleted action',
//       () async {
//         final getComments = MockGetCommentsUseCase();
//         final deleteComment = MockDeleteCommentUseCase();
//         final c1 = makeComment(id: kId1, postId: kId2);
//         final c2 = makeComment(id: kId3, postId: kId2, parentCommentId: kId1);
//         when(
//           () => getComments(
//             any(),
//             page: any(named: 'page'),
//             limit: any(named: 'limit'),
//             sort: any(named: 'sort'),
//             fields: any(named: 'fields'),
//             keyword: any(named: 'keyword'),
//           ),
//         ).thenAnswer((_) async => Right(<Comment>[c1, c2]));
//         when(() => deleteComment(any())).thenAnswer((_) async => const Right(null));
//         final cubit = _buildCubit(getComments: getComments, deleteComment: deleteComment);
//         await cubit.getComments(kId2);

//         final states = await _captureStates(
//           cubit.stream,
//           () => cubit.deleteComment(kId1),
//         );

//         expect(states.last.runtimeType.toString(), 'CommentActionSuccess');
//         expect((states.last as CommentActionSuccess).message, 'deleted');
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - CommentCubit rolls back optimistic reaction on chooseReaction failure',
//       () async {
//         final getComments = MockGetCommentsUseCase();
//         final react = MockReactToCommentUseCase();
//         final base = makeComment(
//           id: kId1,
//           postId: kId2,
//           reaction: ReactionType.none,
//           reactionsCount: 0,
//           reactions: const <Reaction>[],
//         );
//         when(
//           () => getComments(
//             any(),
//             page: any(named: 'page'),
//             limit: any(named: 'limit'),
//             sort: any(named: 'sort'),
//             fields: any(named: 'fields'),
//             keyword: any(named: 'keyword'),
//           ),
//         ).thenAnswer((_) async => Right(<Comment>[base]));
//         when(
//           () => react(
//             commentId: any(named: 'commentId'),
//             reactionType: any(named: 'reactionType'),
//             isUpdate: any(named: 'isUpdate'),
//             reactionId: any(named: 'reactionId'),
//           ),
//         ).thenAnswer((_) async => Left(serverFail('update_failed')));
//         final cubit = _buildCubit(getComments: getComments, reactToComment: react);
//         await cubit.getComments(kId2);

//         final states = await _captureStates(
//           cubit.stream,
//           () => cubit.chooseReactionOnComment(
//             commentId: kId1,
//             currentUserId: kUser1,
//             chosenReaction: ReactionType.like,
//             currentReaction: ReactionType.none,
//           ),
//         );

//         expect(states.map((s) => s.runtimeType.toString()), contains('CommentActionError'));
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - CommentCubit toggleRepliesVisibility expands on successful fetch',
//       () async {
//         final getComments = MockGetCommentsUseCase();
//         final getReplies = MockGetRepliesUseCase();
//         final getReactions = MockGetCommentReactionsUseCase();
//         final parent = makeComment(id: kId1, postId: kId2, repliesCount: 0);
//         final reply = makeComment(id: kId3, postId: kId2, parentCommentId: kId1);
//         when(
//           () => getComments(
//             any(),
//             page: any(named: 'page'),
//             limit: any(named: 'limit'),
//             sort: any(named: 'sort'),
//             fields: any(named: 'fields'),
//             keyword: any(named: 'keyword'),
//           ),
//         ).thenAnswer((_) async => Right(<Comment>[parent]));
//         when(
//           () => getReplies(
//             any(),
//             page: any(named: 'page'),
//             limit: any(named: 'limit'),
//             sort: any(named: 'sort'),
//             fields: any(named: 'fields'),
//             keyword: any(named: 'keyword'),
//           ),
//         ).thenAnswer((_) async => Right(<Comment>[reply]));
//         when(() => getReactions(commentId: any(named: 'commentId')))
//             .thenAnswer((_) async => const Right(<Reaction>[]));
//         final cubit = _buildCubit(
//           getComments: getComments,
//           getReplies: getReplies,
//           getCommentReactions: getReactions,
//         );
//         await cubit.getComments(kId2);

//         await cubit.toggleRepliesVisibility(
//           parentCommentId: kId1,
//           postId: kId2,
//           currentUserId: kUser1,
//         );

//         expect(cubit.isRepliesExpanded(kId1), isTrue);
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - CommentCubit triggerReply/triggerEdit/cancel helpers keep state consistent',
//       () async {
//         final cubit = _buildCubit();
//         final c = makeComment(id: kId1);

//         cubit.triggerReply(c);
//         expect(cubit.replyingTo?.id, kId1);
//         expect(cubit.editingComment, isNull);

//         cubit.triggerEdit(c);
//         expect(cubit.editingComment?.id, kId1);
//         expect(cubit.replyingTo, isNull);
//         expect(cubit.state.runtimeType.toString(), 'CommentEditState');

//         cubit.cancelReplyOrEdit();
//         expect(cubit.editingComment, isNull);
//         expect(cubit.replyingTo, isNull);
//         expect(cubit.state.runtimeType.toString(), 'CommentLoaded');
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - CommentCubit hydrateCurrentUserReactions updates comments when user reaction exists',
//       () async {
//         final getComments = MockGetCommentsUseCase();
//         final getCommentReactions = MockGetCommentReactionsUseCase();
//         final base = makeComment(id: kId1, postId: kId2, reaction: ReactionType.none);
//         when(
//           () => getComments(
//             any(),
//             page: any(named: 'page'),
//             limit: any(named: 'limit'),
//             sort: any(named: 'sort'),
//             fields: any(named: 'fields'),
//             keyword: any(named: 'keyword'),
//           ),
//         ).thenAnswer((_) async => Right(<Comment>[base]));
//         when(() => getCommentReactions(commentId: any(named: 'commentId'))).thenAnswer(
//           (_) async => Right(<Reaction>[makeReaction(userId: kUser1, postId: kId2)]),
//         );
//         final cubit = _buildCubit(
//           getComments: getComments,
//           getCommentReactions: getCommentReactions,
//         );
//         await cubit.getComments(kId2);

//         final states = await _captureStates(
//           cubit.stream,
//           () => cubit.hydrateCurrentUserReactions(currentUserId: kUser1),
//         );

//         expect(states.last.runtimeType.toString(), 'CommentLoaded');
//         final loaded = cubit.state as CommentLoaded;
//         expect(loaded.comments.first.userReaction, ReactionType.like);
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - CommentCubit emits success for hideComment and reportComment',
//       () async {
//         final getComments = MockGetCommentsUseCase();
//         when(
//           () => getComments(
//             any(),
//             page: any(named: 'page'),
//             limit: any(named: 'limit'),
//             sort: any(named: 'sort'),
//             fields: any(named: 'fields'),
//             keyword: any(named: 'keyword'),
//           ),
//         ).thenAnswer((_) async => Right(<Comment>[makeComment(id: kId1)]));
//         final cubit = _buildCubit(getComments: getComments);
//         await cubit.getComments(kId2);

//         final hideStates = await _captureStates(cubit.stream, () => cubit.hideComment(kId1));
//         final hideSuccess = hideStates.whereType<CommentActionSuccess>().toList();
//         expect(hideSuccess, isNotEmpty);
//         expect(hideSuccess.last.message, 'hidden');

//         final reportStates = await _captureStates(cubit.stream, () => cubit.reportComment(kId1));
//         final reportSuccess = reportStates.whereType<CommentActionSuccess>().toList();
//         expect(reportSuccess, isNotEmpty);
//         expect(reportSuccess.first.message, 'reported');
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - CommentCubit handles add and edit failures with action errors',
//       () async {
//         final addComment = MockAddCommentUseCase();
//         final editComment = MockEditCommentUseCase();
//         final getComments = MockGetCommentsUseCase();
//         when(
//           () => getComments(
//             any(),
//             page: any(named: 'page'),
//             limit: any(named: 'limit'),
//             sort: any(named: 'sort'),
//             fields: any(named: 'fields'),
//             keyword: any(named: 'keyword'),
//           ),
//         ).thenAnswer((_) async => Right(<Comment>[makeComment(id: kId1)]));
//         when(
//           () => addComment(
//             postId: any(named: 'postId'),
//             text: any(named: 'text'),
//             parentCommentId: any(named: 'parentCommentId'),
//           ),
//         ).thenAnswer((_) async => Left(serverFail('add_failed')));
//         when(
//           () => editComment(commentId: any(named: 'commentId'), newContent: any(named: 'newContent')),
//         ).thenAnswer((_) async => Left(serverFail('update_failed')));
//         final cubit = _buildCubit(
//           getComments: getComments,
//           addComment: addComment,
//           editComment: editComment,
//         );
//         await cubit.getComments(kId2);

//         final addStates = await _captureStates(
//           cubit.stream,
//           () => cubit.addOrUpdateComment(kId2, 'x'),
//         );
//         expect(addStates, isNotEmpty);
//         expect(addStates.any((s) => s.runtimeType.toString() == 'CommentActionError'), isTrue);

//         cubit.triggerEdit(makeComment(id: kId1));
//         final editStates = await _captureStates(
//           cubit.stream,
//           () => cubit.addOrUpdateComment(kId2, 'y'),
//         );
//         expect(editStates.last.runtimeType.toString(), 'CommentActionError');
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - CommentCubit delete failure restores and emits error',
//       () async {
//         final getComments = MockGetCommentsUseCase();
//         final deleteComment = MockDeleteCommentUseCase();
//         when(
//           () => getComments(
//             any(),
//             page: any(named: 'page'),
//             limit: any(named: 'limit'),
//             sort: any(named: 'sort'),
//             fields: any(named: 'fields'),
//             keyword: any(named: 'keyword'),
//           ),
//         ).thenAnswer((_) async => Right(<Comment>[makeComment(id: kId1)]));
//         when(() => deleteComment(any())).thenAnswer((_) async => Left(serverFail('delete_failed')));
//         final cubit = _buildCubit(getComments: getComments, deleteComment: deleteComment);
//         await cubit.getComments(kId2);

//         final states = await _captureStates(cubit.stream, () => cubit.deleteComment(kId1));
//         expect(states.any((s) => s.runtimeType.toString() == 'CommentActionError'), isTrue);
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - CommentCubit toggleReactionOnComment rollback and success paths',
//       () async {
//         final getComments = MockGetCommentsUseCase();
//         final removeReaction = MockRemoveReactionFromCommentUseCase();
//         final react = MockReactToCommentUseCase();
//         final comment = makeComment(
//           id: kId1,
//           postId: kId2,
//           reaction: ReactionType.like,
//           reactionsCount: 1,
//           reactions: <Reaction>[makeReaction(id: kId3, userId: kUser1, postId: kId2)],
//         );
//         when(
//           () => getComments(
//             any(),
//             page: any(named: 'page'),
//             limit: any(named: 'limit'),
//             sort: any(named: 'sort'),
//             fields: any(named: 'fields'),
//             keyword: any(named: 'keyword'),
//           ),
//         ).thenAnswer((_) async => Right(<Comment>[comment]));
//         when(
//           () => removeReaction(commentId: any(named: 'commentId'), reactionId: any(named: 'reactionId')),
//         ).thenAnswer((_) async => Left(serverFail('update_failed')));
//         when(
//           () => react(
//             commentId: any(named: 'commentId'),
//             reactionType: any(named: 'reactionType'),
//             isUpdate: any(named: 'isUpdate'),
//             reactionId: any(named: 'reactionId'),
//           ),
//         ).thenAnswer((_) async => Right(kId3));

//         final cubit = _buildCubit(
//           getComments: getComments,
//           removeReaction: removeReaction,
//           reactToComment: react,
//         );
//         await cubit.getComments(kId2);

//         await _captureStates(
//           cubit.stream,
//           () => cubit.toggleReactionOnComment(
//             commentId: kId1,
//             currentUserId: kUser1,
//             currentReaction: ReactionType.like,
//           ),
//         );
//         expect(cubit.state.runtimeType.toString(), 'CommentLoaded');
//         final current = cubit.state as CommentLoaded;
//         expect(current.comments.first.userReaction, ReactionType.like);

//         await _captureStates(
//           cubit.stream,
//           () => cubit.toggleReactionOnComment(
//             commentId: kId1,
//             currentUserId: kUser1,
//             currentReaction: ReactionType.none,
//           ),
//         );
//         expect(cubit.state.runtimeType.toString(), 'CommentLoaded');
//         final afterSuccess = cubit.state as CommentLoaded;
//         expect(afterSuccess.comments.first.userReaction, ReactionType.like);
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - CommentCubit toggles replies closed on second call and handles no-op hydration guard',
//       () async {
//         final getComments = MockGetCommentsUseCase();
//         final getReplies = MockGetRepliesUseCase();
//         final parent = makeComment(id: kId1, postId: kId2);
//         when(
//           () => getComments(
//             any(),
//             page: any(named: 'page'),
//             limit: any(named: 'limit'),
//             sort: any(named: 'sort'),
//             fields: any(named: 'fields'),
//             keyword: any(named: 'keyword'),
//           ),
//         ).thenAnswer((_) async => Right(<Comment>[parent]));
//         when(
//           () => getReplies(
//             any(),
//             page: any(named: 'page'),
//             limit: any(named: 'limit'),
//             sort: any(named: 'sort'),
//             fields: any(named: 'fields'),
//             keyword: any(named: 'keyword'),
//           ),
//         ).thenAnswer((_) async => const Right(<Comment>[]));
//         final cubit = _buildCubit(getComments: getComments, getReplies: getReplies);
//         await cubit.getComments(kId2);

//         await cubit.toggleRepliesVisibility(
//           parentCommentId: kId1,
//           postId: kId2,
//           currentUserId: '',
//         );
//         expect(cubit.isRepliesExpanded(kId1), isTrue);

//         await cubit.toggleRepliesVisibility(
//           parentCommentId: kId1,
//           postId: kId2,
//           currentUserId: '',
//         );
//         expect(cubit.isRepliesExpanded(kId1), isFalse);
//         expect(cubit.isRepliesLoading(kId1), isFalse);
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - CommentCubit chooseReaction success updates cached reaction id path',
//       () async {
//         final getComments = MockGetCommentsUseCase();
//         final react = MockReactToCommentUseCase();
//         final comment = makeComment(id: kId1, postId: kId2, reaction: ReactionType.none);
//         when(
//           () => getComments(
//             any(),
//             page: any(named: 'page'),
//             limit: any(named: 'limit'),
//             sort: any(named: 'sort'),
//             fields: any(named: 'fields'),
//             keyword: any(named: 'keyword'),
//           ),
//         ).thenAnswer((_) async => Right(<Comment>[comment]));
//         when(
//           () => react(
//             commentId: any(named: 'commentId'),
//             reactionType: any(named: 'reactionType'),
//             isUpdate: any(named: 'isUpdate'),
//             reactionId: any(named: 'reactionId'),
//           ),
//         ).thenAnswer((_) async => Right(kId3));
//         final cubit = _buildCubit(getComments: getComments, reactToComment: react);
//         await cubit.getComments(kId2);

//         await cubit.chooseReactionOnComment(
//           commentId: kId1,
//           currentUserId: kUser1,
//           chosenReaction: ReactionType.like,
//           currentReaction: ReactionType.none,
//         );

//         expect(cubit.state.runtimeType.toString(), 'CommentLoaded');
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - CommentCubit getRepliesForComment emits loaded when emitState is true',
//       () async {
//         final getComments = MockGetCommentsUseCase();
//         final getReplies = MockGetRepliesUseCase();
//         when(
//           () => getComments(
//             any(),
//             page: any(named: 'page'),
//             limit: any(named: 'limit'),
//             sort: any(named: 'sort'),
//             fields: any(named: 'fields'),
//             keyword: any(named: 'keyword'),
//           ),
//         ).thenAnswer((_) async => Right(<Comment>[makeComment(id: kId1, postId: kId2)]));
//         when(
//           () => getReplies(
//             any(),
//             page: any(named: 'page'),
//             limit: any(named: 'limit'),
//             sort: any(named: 'sort'),
//             fields: any(named: 'fields'),
//             keyword: any(named: 'keyword'),
//           ),
//         ).thenAnswer((_) async => Right(<Comment>[makeComment(id: kId3, postId: kId2, parentCommentId: kId1)]));
//         final cubit = _buildCubit(getComments: getComments, getReplies: getReplies);
//         await cubit.getComments(kId2);

//         final ok = await cubit.getRepliesForComment(kId1, emitState: true);

//         expect(ok, isTrue);
//         expect(cubit.state.runtimeType.toString(), 'CommentLoaded');
//         await cubit.close();
//       },
//     );
//   });
// }
