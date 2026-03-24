// import 'package:auth/core/errors/failure.dart';
// import 'package:auth/domain/entities/post.dart';
// import 'package:auth/domain/entities/reaction.dart';
// import 'package:auth/domain/entities/reaction_type.dart';
// import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
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

// PostCubit _buildCubit({
//   required MockGetPostsUseCase getPosts,
//   MockGetPostReactionsUseCase? getReactions,
//   MockDeletePostUseCase? deletePost,
//   MockEditPostUseCase? editPost,
//   MockSharedPreferences? prefs,
// }) {
//   final effectivePrefs = prefs ?? MockSharedPreferences();
//   if (prefs == null) {
//     when(() => effectivePrefs.getString(any())).thenReturn(null);
//   }
//   when(() => effectivePrefs.setString(any(), any())).thenAnswer((_) async => true);

//   return PostCubit(
//     getPostsUseCase: getPosts,
//     getPostReactionsUseCase: getReactions ?? MockGetPostReactionsUseCase(),
//     deletePostUseCase: deletePost ?? MockDeletePostUseCase(),
//     editPostUseCase: editPost ?? MockEditPostUseCase(),
//     prefs: effectivePrefs,
//   );
// }

// void main() {
//   group('PostCubit deep behavior', () {
//     test(
//       'Unit Test - PostCubit emits [Loading, Success] with hasReachedMax when fetch is empty',
//       () async {
//         final getPosts = MockGetPostsUseCase();
//         when(() => getPosts(page: any(named: 'page'), limit: any(named: 'limit')))
//             .thenAnswer((_) async => const Right(<Post>[]));
//         final cubit = _buildCubit(getPosts: getPosts);

//         final states = await _captureStates(
//           cubit.stream,
//           () => cubit.fetchPosts(refresh: true),
//         );
//         expect(states[0].runtimeType.toString(), 'PostLoading');
//         expect(states[1].runtimeType.toString(), 'PostLoaded');
//         expect((states[1] as PostLoaded).hasReachedMax, isTrue);
//         expect(cubit.page, 1);
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - PostCubit resets page and feed on refresh',
//       () async {
//         final getPosts = MockGetPostsUseCase();
//         when(() => getPosts(page: any(named: 'page'), limit: any(named: 'limit')))
//             .thenAnswer((_) async => Right(<Post>[makePost(id: kId1)]));
//         final cubit = _buildCubit(getPosts: getPosts);
//         cubit.posts = <Post>[makePost(id: kId2)];
//         cubit.page = 5;
//         cubit.hasReachedMax = true;

//         await cubit.fetchPosts(refresh: true);

//         expect(cubit.posts.length, 1);
//         expect(cubit.posts.first.postID, kId1);
//         expect(cubit.page, 2);
//         expect(cubit.hasReachedMax, isFalse);
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - PostCubit emits loading-more success and deduplicates posts',
//       () async {
//         final getPosts = MockGetPostsUseCase();
//         when(() => getPosts(page: any(named: 'page'), limit: any(named: 'limit')))
//             .thenAnswer((_) async => Right(<Post>[makePost(id: kId1), makePost(id: kId2)]));
//         final cubit = _buildCubit(getPosts: getPosts);
//         cubit.posts = <Post>[makePost(id: kId1)];
//         cubit.page = 2;

//         final states = await _captureStates(cubit.stream, cubit.loadMorePosts);

//         expect(states.map((s) => s.runtimeType.toString()).toList(), <String>[
//           'PostsLoadingMore',
//           'PostLoaded',
//         ]);
//         expect(cubit.posts.length, 2);
//         expect(cubit.posts.map((e) => e.postID).toSet().length, 2);
//         expect(cubit.page, 3);
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - PostCubit marks end-of-feed when loadMore returns empty',
//       () async {
//         final getPosts = MockGetPostsUseCase();
//         when(() => getPosts(page: any(named: 'page'), limit: any(named: 'limit')))
//             .thenAnswer((_) async => const Right(<Post>[]));
//         final cubit = _buildCubit(getPosts: getPosts);
//         cubit.posts = <Post>[makePost(id: kId1)];

//         await cubit.loadMorePosts();

//         expect(cubit.hasReachedMax, isTrue);
//         expect(cubit.state.runtimeType.toString(), 'PostLoaded');
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - PostCubit emits [Loading, Failure] when loadMore fails',
//       () async {
//         final getPosts = MockGetPostsUseCase();
//         when(() => getPosts(page: any(named: 'page'), limit: any(named: 'limit')))
//             .thenAnswer((_) async => const Left(ServerFailure('x')));
//         final cubit = _buildCubit(getPosts: getPosts);
//         cubit.posts = <Post>[makePost()];

//         final states = await _captureStates(cubit.stream, cubit.loadMorePosts);
//         expect(states.map((s) => s.runtimeType.toString()).toList(), <String>[
//           'PostsLoadingMore',
//           'PostsLoadingMoreError',
//         ]);
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - PostCubit updates local cache/list correctly when adding new post',
//       () async {
//         final getPosts = MockGetPostsUseCase();
//         final prefs = MockSharedPreferences();
//         when(() => prefs.getString(any())).thenReturn(null);
//         when(() => prefs.setString(any(), any())).thenAnswer((_) async => true);
//         final cubit = _buildCubit(getPosts: getPosts, prefs: prefs);
//         cubit.posts = <Post>[makePost(id: kId2)];

//         cubit.addNewPostToFeed(makePost(id: kId1));

//         expect(cubit.posts.first.postID, kId1);
//         expect(cubit.state.runtimeType.toString(), 'PostLoaded');
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - PostCubit persists comments counters after increment/decrement',
//       () async {
//         final getPosts = MockGetPostsUseCase();
//         final prefs = MockSharedPreferences();
//         when(() => prefs.getString(any())).thenReturn(null);
//         when(() => prefs.setString(any(), any())).thenAnswer((_) async => true);
//         final cubit = _buildCubit(getPosts: getPosts, prefs: prefs);
//         cubit.posts = <Post>[makePost(id: kId1, commentsCount: 1)];

//         cubit.incrementCommentsCount(kId1, by: 1);
//         cubit.incrementCommentsCount(kId1, by: -1);

//         expect(cubit.posts.first.commentsCount, 1);
//         verify(() => prefs.setString(any(), any())).called(greaterThanOrEqualTo(2));
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - PostCubit updates reaction count and snapshot cache',
//       () async {
//         final getPosts = MockGetPostsUseCase();
//         final prefs = MockSharedPreferences();
//         when(() => prefs.getString(any())).thenReturn(null);
//         when(() => prefs.setString(any(), any())).thenAnswer((_) async => true);
//         final cubit = _buildCubit(getPosts: getPosts, prefs: prefs);
//         cubit.posts = <Post>[makePost(id: kId1, reactionsCount: 0)];

//         cubit.updatePostReaction(
//           postId: kId1,
//           currentUserId: kUser1,
//           reactionType: ReactionType.like,
//           reactionsCount: 0,
//           reactionId: kId3,
//         );

//         expect(cubit.posts.first.reactionsCount, 1);
//         expect(cubit.posts.first.userReaction, ReactionType.like);
//         verify(() => prefs.setString(any(), any())).called(greaterThan(0));
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - PostCubit maps delete failures to expected errorType/message',
//       () async {
//         final getPosts = MockGetPostsUseCase();
//         final deletePost = MockDeletePostUseCase();
//         when(() => deletePost(any())).thenAnswer((_) async => const Left(NetworkFailure('net')));
//         final cubit = _buildCubit(getPosts: getPosts, deletePost: deletePost);
//         final post = makePost(id: kId1);
//         cubit.posts = <Post>[post];

//         await cubit.deletePost(post: post);

//         expect(cubit.state.runtimeType.toString(), 'DeletePostError');
//         expect((cubit.state as DeletePostError).errorType, 'network');
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - PostCubit emits delete success and removes post from local list',
//       () async {
//         final getPosts = MockGetPostsUseCase();
//         final deletePost = MockDeletePostUseCase();
//         when(() => deletePost(any())).thenAnswer((_) async => const Right(null));
//         final cubit = _buildCubit(getPosts: getPosts, deletePost: deletePost);
//         final post = makePost(id: kId1);
//         cubit.posts = <Post>[post, makePost(id: kId2)];

//         final states = await _captureStates(cubit.stream, () => cubit.deletePost(post: post));

//         expect(states.map((s) => s.runtimeType.toString()).toList(), <String>[
//           'DeletePostLoading',
//           'PostLoaded',
//           'DeletePostSuccess',
//         ]);
//         expect(cubit.posts.map((p) => p.postID), isNot(contains(kId1)));
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - PostCubit replaces edited post and emits edit success',
//       () async {
//         final getPosts = MockGetPostsUseCase();
//         final editPost = MockEditPostUseCase();
//         final updated = makePost(id: kId1, caption: 'updated');
//         when(() => editPost(postId: any(named: 'postId'), caption: any(named: 'caption')))
//             .thenAnswer((_) async => Right(updated));
//         final cubit = _buildCubit(getPosts: getPosts, editPost: editPost);
//         cubit.posts = <Post>[makePost(id: kId1, caption: 'old')];

//         final states = await _captureStates(
//           cubit.stream,
//           () => cubit.editPost(postId: kId1, newCaption: 'updated'),
//         );

//         expect(states.map((s) => s.runtimeType.toString()).toList(), <String>[
//           'EditPostLoading',
//           'PostLoaded',
//           'EditPostSuccess',
//         ]);
//         expect(cubit.posts.first.caption, 'updated');
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - PostCubit hydrates current user reactions and emits updated feed',
//       () async {
//         final getPosts = MockGetPostsUseCase();
//         final getReactions = MockGetPostReactionsUseCase();
//         final prefs = MockSharedPreferences();
//         when(() => prefs.getString(any())).thenReturn(null);
//         when(() => prefs.setString(any(), any())).thenAnswer((_) async => true);
//         when(() => getReactions(postId: any(named: 'postId')))
//             .thenAnswer((_) async => Right(<Reaction>[makeReaction(userId: kUser1)]));
//         final cubit = _buildCubit(
//           getPosts: getPosts,
//           getReactions: getReactions,
//           prefs: prefs,
//         );
//         cubit.posts = <Post>[
//           makePost(id: kId1, reactionsCount: 2, reaction: ReactionType.none, reactions: <Reaction>[]),
//         ];

//         final states = await _captureStates(
//           cubit.stream,
//           () => cubit.hydrateCurrentUserReactions(currentUserId: kUser1),
//         );

//         expect(states.last.runtimeType.toString(), 'PostLoaded');
//         expect(cubit.posts.first.userReaction, ReactionType.like);
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - PostCubit handles malformed cached snapshots safely',
//       () async {
//         final getPosts = MockGetPostsUseCase();
//         final prefs = MockSharedPreferences();
//         when(() => prefs.getString(any())).thenAnswer((invocation) {
//           final key = invocation.positionalArguments.first as String;
//           if (key == 'post_reactions_snapshot') return '{bad-json';
//           if (key == 'post_comments_count_floors') return '{bad-json';
//           if (key == 'post_comments_count_ceilings') return '{bad-json';
//           return null;
//         });
//         when(() => prefs.setString(any(), any())).thenAnswer((_) async => true);
//         when(() => getPosts(page: any(named: 'page'), limit: any(named: 'limit')))
//             .thenAnswer((_) async => Right(<Post>[makePost(id: kId1)]));
//         final cubit = _buildCubit(getPosts: getPosts, prefs: prefs);

//         await cubit.fetchPosts(refresh: true);

//         expect(cubit.state.runtimeType.toString(), 'PostLoaded');
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - PostCubit applies cached floors/ceilings and persists cache cleanup',
//       () async {
//         final getPosts = MockGetPostsUseCase();
//         final prefs = MockSharedPreferences();
//         when(() => prefs.getString(any())).thenAnswer((invocation) {
//           final key = invocation.positionalArguments.first as String;
//           if (key == 'post_comments_count_floors') return '{"$kId1": "5"}';
//           if (key == 'post_comments_count_ceilings') return '{"$kId1": 8}';
//           return null;
//         });
//         when(() => prefs.setString(any(), any())).thenAnswer((_) async => true);
//         when(() => getPosts(page: any(named: 'page'), limit: any(named: 'limit')))
//             .thenAnswer((_) async => Right(<Post>[makePost(id: kId1, commentsCount: 6)]));
//         final cubit = _buildCubit(getPosts: getPosts, prefs: prefs);

//         await cubit.fetchPosts(refresh: true);

//         expect(cubit.posts.first.commentsCount, 6);
//         verify(() => prefs.setString(any(), any())).called(greaterThan(0));
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - PostCubit applies reactions snapshot and normalizes counts',
//       () async {
//         final getPosts = MockGetPostsUseCase();
//         final prefs = MockSharedPreferences();
//         when(() => prefs.getString(any())).thenAnswer((invocation) {
//           final key = invocation.positionalArguments.first as String;
//           if (key == 'post_reactions_snapshot') {
//             return '{"$kId1":{"count":"3","reaction":"like"}}';
//           }
//           return null;
//         });
//         when(() => prefs.setString(any(), any())).thenAnswer((_) async => true);
//         when(() => getPosts(page: any(named: 'page'), limit: any(named: 'limit')))
//             .thenAnswer((_) async => Right(<Post>[makePost(id: kId1, reactionsCount: 0)]));
//         final cubit = _buildCubit(getPosts: getPosts, prefs: prefs);

//         await cubit.fetchPosts(refresh: true);

//         expect(cubit.posts.first.reactionsCount, 3);
//         expect(cubit.posts.first.userReaction, ReactionType.like);
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - PostCubit handles updatePostReaction remove branch for existing reaction',
//       () async {
//         final getPosts = MockGetPostsUseCase();
//         final prefs = MockSharedPreferences();
//         when(() => prefs.getString(any())).thenReturn(null);
//         when(() => prefs.setString(any(), any())).thenAnswer((_) async => true);
//         final cubit = _buildCubit(getPosts: getPosts, prefs: prefs);
//         cubit.posts = <Post>[
//           makePost(
//             id: kId1,
//             reactionsCount: 1,
//             reaction: ReactionType.like,
//             reactions: <Reaction>[makeReaction(id: kId3, userId: kUser1, postId: kId1)],
//           ),
//         ];

//         cubit.updatePostReaction(
//           postId: kId1,
//           currentUserId: kUser1,
//           reactionType: ReactionType.none,
//           reactionsCount: 0,
//         );

//         expect(cubit.posts.first.userReaction, ReactionType.none);
//         expect(cubit.posts.first.reactions, isEmpty);
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - PostCubit marks hasReachedMax when loadMore contains only duplicates',
//       () async {
//         final getPosts = MockGetPostsUseCase();
//         when(() => getPosts(page: any(named: 'page'), limit: any(named: 'limit')))
//             .thenAnswer((_) async => Right(<Post>[makePost(id: kId1)]));
//         final cubit = _buildCubit(getPosts: getPosts);
//         cubit.posts = <Post>[makePost(id: kId1)];
//         cubit.page = 2;

//         await cubit.loadMorePosts();

//         expect(cubit.hasReachedMax, isTrue);
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - PostCubit parses int floor and string ceiling cache values',
//       () async {
//         final getPosts = MockGetPostsUseCase();
//         final prefs = MockSharedPreferences();
//         when(() => prefs.getString(any())).thenAnswer((invocation) {
//           final key = invocation.positionalArguments.first as String;
//           if (key == 'post_comments_count_floors') return '{"$kId1": 5}';
//           if (key == 'post_comments_count_ceilings') return '{"$kId1": "9"}';
//           return null;
//         });
//         when(() => prefs.setString(any(), any())).thenAnswer((_) async => true);
//         when(() => getPosts(page: any(named: 'page'), limit: any(named: 'limit')))
//             .thenAnswer((_) async => Right(<Post>[makePost(id: kId1, commentsCount: 1)]));
//         final cubit = _buildCubit(getPosts: getPosts, prefs: prefs);

//         await cubit.fetchPosts(refresh: true);

//         expect(cubit.posts.first.commentsCount, 5);
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - PostCubit emits edit failure state on editPost error',
//       () async {
//         final getPosts = MockGetPostsUseCase();
//         final editPost = MockEditPostUseCase();
//         when(() => editPost(postId: any(named: 'postId'), caption: any(named: 'caption')))
//             .thenAnswer((_) async => Left(serverFail('edit_failed')));
//         final cubit = _buildCubit(getPosts: getPosts, editPost: editPost);

//         await cubit.editPost(postId: kId1, newCaption: 'x');

//         expect(cubit.state.runtimeType.toString(), 'EditPostError');
//         expect((cubit.state as EditPostError).message, 'edit_failed');
//         await cubit.close();
//       },
//     );
//   });
// }
