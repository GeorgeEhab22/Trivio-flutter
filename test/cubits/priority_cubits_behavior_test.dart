// import 'package:auth/core/errors/failure.dart';
// import 'package:auth/domain/entities/comment.dart';
// import 'package:auth/domain/entities/post.dart';
// import 'package:auth/domain/entities/reaction_type.dart';
// import 'package:auth/domain/entities/user.dart';
// import 'package:auth/presentation/manager/comment_cubit/comment_cubit.dart';
// import 'package:auth/presentation/manager/group_cubit/get_group_posts/group_posts_cubit.dart';
// import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
// import 'package:auth/presentation/manager/register_cubit/register_cubit.dart';
// import 'package:auth/presentation/manager/sigin_in_cubit/sign_in_cubit.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';

// import 'non_follow_cubits_test.dart';

// Future<List<String>> _captureStateTypes(
//   Stream<dynamic> stream,
//   Future<void> Function() act, {
//   Duration settle = const Duration(milliseconds: 20),
// }) async {
//   final types = <String>[];
//   final sub = stream.listen((state) => types.add(state.runtimeType.toString()));
//   await act();
//   if (settle > Duration.zero) {
//     await Future<void>.delayed(settle);
//   }
//   await sub.cancel();
//   return types;
// }

// Post _samplePost({String id = '507f1f77bcf86cd799439011'}) => Post(
//   postID: id,
//   type: 'text',
//   caption: 'hello',
//   commentsCount: 0,
//   reactionsCount: 0,
//   userReaction: ReactionType.none,
// );

// Comment _sampleComment({String id = '507f1f77bcf86cd799439021'}) => Comment(
//   id: id,
//   postId: '507f1f77bcf86cd799439011',
//   authorId: '507f1f77bcf86cd799439031',
//   authorName: 'u',
//   text: 'c',
//   createdAt: DateTime(2024, 1, 1),
// );

// void main() {
//   group('Priority behavior tests', () {
//     group('PostCubit', () {
//       test(
//         'Unit Test - PostCubit emits [Loading, Success] on successful use case',
//         () async {
//           final getPosts = MockGetPostsUseCase();
//           final getReactions = MockGetPostReactionsUseCase();
//           final deletePost = MockDeletePostUseCase();
//           final editPost = MockEditPostUseCase();
//           final prefs = MockSharedPreferences();

//           when(() => prefs.getString(any())).thenReturn(null);
//           when(() => prefs.setString(any(), any())).thenAnswer((_) async => true);
//           when(() => getPosts(page: any(named: 'page'), limit: any(named: 'limit')))
//               .thenAnswer((_) async => Right(<Post>[_samplePost()]));

//           final cubit = PostCubit(
//             getPostsUseCase: getPosts,
//             getPostReactionsUseCase: getReactions,
//             deletePostUseCase: deletePost,
//             editPostUseCase: editPost,
//             prefs: prefs,
//           );

//           final types = await _captureStateTypes(
//             cubit.stream,
//             () => cubit.fetchPosts(refresh: true),
//           );

//           expect(types, ['PostLoading', 'PostLoaded']);
//           verify(() => getPosts(page: 1, limit: 10)).called(1);
//           await cubit.close();
//         },
//       );

//       test(
//         'Unit Test - PostCubit emits [Loading, Failure] on failed use case',
//         () async {
//           final getPosts = MockGetPostsUseCase();
//           final prefs = MockSharedPreferences();
//           when(() => prefs.getString(any())).thenReturn(null);
//           when(() => getPosts(page: any(named: 'page'), limit: any(named: 'limit')))
//               .thenAnswer((_) async => const Left(ServerFailure('boom')));

//           final cubit = PostCubit(
//             getPostsUseCase: getPosts,
//             getPostReactionsUseCase: MockGetPostReactionsUseCase(),
//             deletePostUseCase: MockDeletePostUseCase(),
//             editPostUseCase: MockEditPostUseCase(),
//             prefs: prefs,
//           );

//           final types = await _captureStateTypes(
//             cubit.stream,
//             () => cubit.fetchPosts(refresh: true),
//           );

//           expect(types, ['PostLoading', 'PostError']);
//           await cubit.close();
//         },
//       );

//       test(
//         'Unit Test - PostCubit ignores duplicate concurrent calls',
//         () async {
//           final getPosts = MockGetPostsUseCase();
//           final prefs = MockSharedPreferences();
//           when(() => prefs.getString(any())).thenReturn(null);

//           final cubit = PostCubit(
//             getPostsUseCase: getPosts,
//             getPostReactionsUseCase: MockGetPostReactionsUseCase(),
//             deletePostUseCase: MockDeletePostUseCase(),
//             editPostUseCase: MockEditPostUseCase(),
//             prefs: prefs,
//           );
//           cubit.isLoadingMore = true;

//           final types = await _captureStateTypes(cubit.stream, cubit.loadMorePosts);
//           expect(types, isEmpty);
//           verifyNever(() => getPosts(page: any(named: 'page'), limit: any(named: 'limit')));
//           await cubit.close();
//         },
//       );
//     });

//     group('CommentCubit', () {
//       test(
//         'Unit Test - CommentCubit emits [Loading, Success] on successful use case',
//         () async {
//           final getComments = MockGetCommentsUseCase();
//           final getReplies = MockGetRepliesUseCase();
//           when(
//             () => getComments(
//               any(),
//               page: any(named: 'page'),
//               limit: any(named: 'limit'),
//               sort: any(named: 'sort'),
//               fields: any(named: 'fields'),
//               keyword: any(named: 'keyword'),
//             ),
//           ).thenAnswer((_) async => Right(<Comment>[_sampleComment()]));
//           when(
//             () => getReplies(
//               any(),
//               page: any(named: 'page'),
//               limit: any(named: 'limit'),
//               sort: any(named: 'sort'),
//               fields: any(named: 'fields'),
//               keyword: any(named: 'keyword'),
//             ),
//           ).thenAnswer((_) async => const Right(<Comment>[]));

//           final cubit = CommentCubit(
//             getCommentsUseCase: getComments,
//             getCommentUseCase: MockGetCommentUseCase(),
//             getCommentReactionsUseCase: MockGetCommentReactionsUseCase(),
//             addCommentUseCase: MockAddCommentUseCase(),
//             deleteCommentUseCase: MockDeleteCommentUseCase(),
//             editCommentUseCase: MockEditCommentUseCase(),
//             getRepliesUseCase: getReplies,
//             mentionUsersInCommentUseCase: MockMentionUsersInCommentUseCase(),
//             reactToCommentUseCase: MockReactToCommentUseCase(),
//             removeReactionFromCommentUseCase: MockRemoveReactionFromCommentUseCase(),
//           );

//           final types = await _captureStateTypes(
//             cubit.stream,
//             () => cubit.getComments('507f1f77bcf86cd799439011'),
//           );

//           expect(types, ['CommentLoading', 'CommentLoaded']);
//           await cubit.close();
//         },
//       );

//       test(
//         'Unit Test - CommentCubit emits [Loading, Failure] on failed use case',
//         () async {
//           final getComments = MockGetCommentsUseCase();
//           when(
//             () => getComments(
//               any(),
//               page: any(named: 'page'),
//               limit: any(named: 'limit'),
//               sort: any(named: 'sort'),
//               fields: any(named: 'fields'),
//               keyword: any(named: 'keyword'),
//             ),
//           ).thenAnswer((_) async => const Left(ServerFailure('failed')));

//           final cubit = CommentCubit(
//             getCommentsUseCase: getComments,
//             getCommentUseCase: MockGetCommentUseCase(),
//             getCommentReactionsUseCase: MockGetCommentReactionsUseCase(),
//             addCommentUseCase: MockAddCommentUseCase(),
//             deleteCommentUseCase: MockDeleteCommentUseCase(),
//             editCommentUseCase: MockEditCommentUseCase(),
//             getRepliesUseCase: MockGetRepliesUseCase(),
//             mentionUsersInCommentUseCase: MockMentionUsersInCommentUseCase(),
//             reactToCommentUseCase: MockReactToCommentUseCase(),
//             removeReactionFromCommentUseCase: MockRemoveReactionFromCommentUseCase(),
//           );

//           final types = await _captureStateTypes(
//             cubit.stream,
//             () => cubit.getComments('507f1f77bcf86cd799439011'),
//           );

//           expect(types, ['CommentLoading', 'CommentError']);
//           await cubit.close();
//         },
//       );
//     });

//     group('SignInCubit', () {
//       test(
//         'Unit Test - SignInCubit emits [Loading, Success] on successful use case',
//         () async {
//           final useCase = MockSignInUseCase();
//           when(
//             () => useCase(email: any(named: 'email'), password: any(named: 'password')),
//           ).thenAnswer((_) async => const Right(null));

//           final cubit = SignInCubit(
//             signInUseCase: useCase,
//             googleSignInUseCase: MockGoogleSignInAndRegisterUseCase(),
//           );

//           final types = await _captureStateTypes(
//             cubit.stream,
//             () => cubit.signIn(email: 'test@mail.com', password: '12345678'),
//           );

//           expect(types, ['SignInLoading', 'SignInSuccess']);
//           verify(
//             () => useCase(email: 'test@mail.com', password: '12345678'),
//           ).called(1);
//           await cubit.close();
//         },
//       );

//       test(
//         'Unit Test - SignInCubit maps failures to expected errorType/message',
//         () async {
//           final useCase = MockSignInUseCase();
//           when(
//             () => useCase(email: any(named: 'email'), password: any(named: 'password')),
//           ).thenAnswer((_) async => const Left(NetworkFailure('net')));

//           final cubit = SignInCubit(
//             signInUseCase: useCase,
//             googleSignInUseCase: MockGoogleSignInAndRegisterUseCase(),
//           );

//           await cubit.signIn(email: 'test@mail.com', password: '12345678');
//           expect(cubit.state.runtimeType.toString(), 'SignInFailure');
//           expect((cubit.state as dynamic).errorType, 'network');
//           await cubit.close();
//         },
//       );
//     });

//     group('RegisterCubit', () {
//       test(
//         'Unit Test - RegisterCubit emits [Loading, Success] on successful use case',
//         () async {
//           final useCase = MockRegisterUseCase();
//           when(
//             () => useCase(
//               email: any(named: 'email'),
//               password: any(named: 'password'),
//               username: any(named: 'username'),
//               confirmPassword: any(named: 'confirmPassword'),
//             ),
//           ).thenAnswer(
//             (_) async => const Right(User(email: 't@mail.com', username: 'u')),
//           );

//           final cubit = RegisterCubit(registerUseCase: useCase);
//           final types = await _captureStateTypes(
//             cubit.stream,
//             () => cubit.register(
//               email: 't@mail.com',
//               password: '12345678',
//               username: 'u',
//               confirmPassword: '12345678',
//             ),
//           );

//           expect(types, ['RegisterLoading', 'RegisterSuccess']);
//           await cubit.close();
//         },
//       );

//       test(
//         'Unit Test - RegisterCubit maps failures to expected errorType/message',
//         () async {
//           final useCase = MockRegisterUseCase();
//           when(
//             () => useCase(
//               email: any(named: 'email'),
//               password: any(named: 'password'),
//               username: any(named: 'username'),
//               confirmPassword: any(named: 'confirmPassword'),
//             ),
//           ).thenAnswer((_) async => const Left(AuthFailure('auth')));

//           final cubit = RegisterCubit(registerUseCase: useCase);
//           await cubit.register(
//             email: 't@mail.com',
//             password: '12345678',
//             username: 'u',
//             confirmPassword: '12345678',
//           );

//           expect(cubit.state.runtimeType.toString(), 'RegisterFailure');
//           expect((cubit.state as dynamic).errorType, 'auth');
//           await cubit.close();
//         },
//       );
//     });

//     group('GroupPostsCubit', () {
//       test(
//         'Unit Test - GroupPostsCubit emits [Loading, Success] on successful use case',
//         () async {
//           final getPosts = MockGetGroupPostsUseCase();
//           when(
//             () => getPosts(groupId: any(named: 'groupId'), page: any(named: 'page')),
//           ).thenAnswer((_) async => Right(<Post>[_samplePost(id: '507f1f77bcf86cd799439041')]));

//           final cubit = GroupPostsCubit(
//             getGroupPostsUseCase: getPosts,
//             deleteGroupPostUseCase: MockDeleteGroupPostUseCase(),
//           );

//           final types = await _captureStateTypes(
//             cubit.stream,
//             () => cubit.getPosts(
//               groupId: '507f1f77bcf86cd799439051',
//               refresh: true,
//             ),
//           );

//           expect(types, ['GroupPostsLoading', 'GroupPostsLoaded']);
//           verify(
//             () => getPosts(groupId: '507f1f77bcf86cd799439051', page: 1),
//           ).called(1);
//           await cubit.close();
//         },
//       );

//       test(
//         'Unit Test - GroupPostsCubit emits [Loading, Failure] on failed use case',
//         () async {
//           final getPosts = MockGetGroupPostsUseCase();
//           when(
//             () => getPosts(groupId: any(named: 'groupId'), page: any(named: 'page')),
//           ).thenAnswer((_) async => const Left(ServerFailure('bad')));

//           final cubit = GroupPostsCubit(
//             getGroupPostsUseCase: getPosts,
//             deleteGroupPostUseCase: MockDeleteGroupPostUseCase(),
//           );

//           final types = await _captureStateTypes(
//             cubit.stream,
//             () => cubit.getPosts(
//               groupId: '507f1f77bcf86cd799439051',
//               refresh: true,
//             ),
//           );

//           expect(types, ['GroupPostsLoading', 'GroupPostsError']);
//           await cubit.close();
//         },
//       );

//       test(
//         'Unit Test - GroupPostsCubit ignores duplicate concurrent calls',
//         () async {
//           final getPosts = MockGetGroupPostsUseCase();
//           final cubit = GroupPostsCubit(
//             getGroupPostsUseCase: getPosts,
//             deleteGroupPostUseCase: MockDeleteGroupPostUseCase(),
//           );
//           cubit.isFetching = true;

//           final types = await _captureStateTypes(
//             cubit.stream,
//             () => cubit.getPosts(groupId: '507f1f77bcf86cd799439051'),
//           );

//           expect(types, isEmpty);
//           verifyNever(
//             () => getPosts(groupId: any(named: 'groupId'), page: any(named: 'page')),
//           );
//           await cubit.close();
//         },
//       );
//     });
//   });
// }
