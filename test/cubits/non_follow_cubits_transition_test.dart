// import 'package:auth/core/errors/failure.dart';
// import 'package:auth/domain/entities/group.dart';
// import 'package:auth/domain/entities/group_member.dart';
// import 'package:auth/domain/entities/post.dart';
// import 'package:auth/domain/entities/reaction_type.dart';
// import 'package:auth/presentation/manager/group_cubit/accept_request/accept_request_cubit.dart';
// import 'package:auth/presentation/manager/group_cubit/ban_member/ban_member_cubit.dart';
// import 'package:auth/presentation/manager/group_cubit/cancel_request/cancel_request_group_cubit.dart';
// import 'package:auth/presentation/manager/group_cubit/change_member_role/change_member_role_cubit.dart';
// import 'package:auth/presentation/manager/group_cubit/create_group/create_group_cubit.dart';
// import 'package:auth/presentation/manager/group_cubit/decline_request/decline_request_cubit.dart';
// import 'package:auth/presentation/manager/group_cubit/delete_group/delete_group_cubit.dart';
// import 'package:auth/presentation/manager/group_cubit/get_banned_members/get_banned_members_cubit.dart';
// import 'package:auth/presentation/manager/group_cubit/get_group/get_group_cubit.dart';
// import 'package:auth/presentation/manager/group_cubit/get_group_feed/get_groups_posts_feed_cubit.dart';
// import 'package:auth/presentation/manager/group_cubit/get_groups/get_groups_cubit.dart';
// import 'package:auth/presentation/manager/group_cubit/get_groups/get_groups_state.dart';
// import 'package:auth/presentation/manager/group_cubit/get_join_requests/get_join_requests_cubit.dart';
// import 'package:auth/presentation/manager/group_cubit/get_joined_groups/get_joined_groups_cubit.dart';
// import 'package:auth/presentation/manager/group_cubit/get_members_by_roles/members_cubit.dart';
// import 'package:auth/presentation/manager/group_cubit/get_my_groups/get_my_groups_cubit.dart';
// import 'package:auth/presentation/manager/group_cubit/join_group/join_group_cubit.dart';
// import 'package:auth/presentation/manager/group_cubit/kick_member/kick_member_cubit.dart';
// import 'package:auth/presentation/manager/group_cubit/leave_group/leave_group_cubit.dart';
// import 'package:auth/presentation/manager/group_cubit/unban_member/unban_member_cubit.dart';
// import 'package:auth/presentation/manager/group_cubit/update_group/update_group_cubit.dart';
// import 'package:auth/presentation/manager/locale_cubit/locale_cubit.dart';
// import 'package:auth/presentation/manager/post_cubit/create_post_cubit.dart';
// import 'package:auth/presentation/manager/post_cubit/get_post/get_post_cubit.dart';
// import 'package:auth/presentation/manager/post_cubit/post_interaction_cubit.dart';
// import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
// import 'package:auth/presentation/manager/register_cubit/verify_code_cubit.dart';
// import 'package:auth/presentation/manager/sigin_in_cubit/forget_password_otp_cubit.dart';
// import 'package:auth/presentation/manager/sigin_in_cubit/request_otp/request_otp_cubit.dart';
// import 'package:auth/presentation/manager/stats_cubit/stats_cubit.dart';
// import 'package:auth/presentation/manager/theme_cubit/theme_cubit.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:shared_preferences/shared_preferences.dart';

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

// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();
//   setUpAll(() async {
//     SharedPreferences.setMockInitialValues(<String, Object>{});
//   });

//   group('Non-follow cubits transition tests', () {
//     test(
//       'Unit Test - AcceptRequestCubit emits [Loading, Failure] on failed use case',
//       () async {
//         final useCase = MockAcceptJoinRequestUseCase();
//         when(
//           () => useCase(groupId: any(named: 'groupId'), requestedId: any(named: 'requestedId')),
//         ).thenAnswer((_) async => const Left(ServerFailure('x')));
//         final cubit = AcceptRequestCubit(acceptJoinRequestUseCase: useCase);
//         final types = await _captureStateTypes(
//           cubit.stream,
//           () => cubit.acceptRequest(groupId: 'g', requestId: 'r'),
//         );
//         expect(types, ['AcceptRequestLoading', 'AcceptRequestFailure']);
//         await cubit.close();
//       },
//     );

//     test('Unit Test - BanMemberCubit emits [Loading, Failure] on failed use case', () async {
//       final useCase = MockBanMemberUseCase();
//       when(
//         () => useCase(groupId: any(named: 'groupId'), userId: any(named: 'userId')),
//       ).thenAnswer((_) async => const Left(ServerFailure('x')));
//       final cubit = BanMemberCubit(banMemberUseCase: useCase);
//       final types = await _captureStateTypes(
//         cubit.stream,
//         () => cubit.banMember(groupId: 'g', targetUserId: 'u'),
//       );
//       expect(types, ['BanMemberLoading', 'BanMemberFailure']);
//       await cubit.close();
//     });

//     test(
//       'Unit Test - CancelRequestGroupCubit emits [Loading, Failure] on failed use case',
//       () async {
//         final useCase = MockCancelRequestUseCase();
//         when(() => useCase(groupId: any(named: 'groupId')))
//             .thenAnswer((_) async => const Left(NetworkFailure('x')));
//         final cubit = CancelRequestGroupCubit(cancelRequestUseCase: useCase);
//         final types = await _captureStateTypes(
//           cubit.stream,
//           () => cubit.cancelRequestGroup(groupId: 'g'),
//         );
//         expect(types, ['CancelRequestGroupLoading', 'CancelRequestGroupFailure']);
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - ChangeMemberRoleCubit emits [Loading, Failure] on failed use case',
//       () async {
//         final useCase = MockChangeMemberRoleUseCase();
//         when(
//           () => useCase(
//             groupId: any(named: 'groupId'),
//             userId: any(named: 'userId'),
//             newRole: any(named: 'newRole'),
//           ),
//         ).thenAnswer((_) async => const Left(ServerFailure('x')));
//         final cubit = ChangeMemberRoleCubit(changeMemberRoleUseCase: useCase);
//         final types = await _captureStateTypes(
//           cubit.stream,
//           () => cubit.changeMemberRole(groupId: 'g', userId: 'u', newRole: 'member'),
//         );
//         expect(types, ['ChangeMemberRoleLoading', 'ChangeMemberRoleFailure']);
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - CreateGroupCubit validates required fields',
//       () async {
//         final cubit = CreateGroupCubit(createGroupUseCase: MockCreateGroupUseCase());
//         final isValid = cubit.validateFields();
//         expect(isValid, isFalse);
//         expect(cubit.state.runtimeType.toString(), 'CreateGroupInitial');
//         await cubit.close();
//       },
//     );

//     test('Unit Test - DeclineRequestCubit emits [Loading, Failure] on failed use case', () async {
//       final useCase = MockDeclineJoinRequestUseCase();
//       when(
//         () => useCase(groupId: any(named: 'groupId'), requestedId: any(named: 'requestedId')),
//       ).thenAnswer((_) async => const Left(ServerFailure('x')));
//       final cubit = DeclineRequestCubit(declineJoinRequestUseCase: useCase);
//       final types = await _captureStateTypes(
//         cubit.stream,
//         () => cubit.declineRequest(groupId: 'g', requestId: 'r'),
//       );
//       expect(types, ['DeclineRequestLoading', 'DeclineRequestFailure']);
//       await cubit.close();
//     });

//     test('Unit Test - DeleteGroupCubit emits [Loading, Failure] on failed use case', () async {
//       final useCase = MockDeleteGroupUseCase();
//       when(() => useCase(groupId: any(named: 'groupId')))
//           .thenAnswer((_) async => const Left(NetworkFailure('x')));
//       final cubit = DeleteGroupCubit(deleteGroupUseCase: useCase);
//       final types = await _captureStateTypes(cubit.stream, () => cubit.deleteGroup('g'));
//       expect(types, ['DeleteGroupLoading', 'DeleteGroupFailure']);
//       await cubit.close();
//     });

//     test(
//       'Unit Test - GetBannedMembersCubit emits [Loading, Failure] on failed use case',
//       () async {
//         final useCase = MockGetGroupBannedMembersUseCase();
//         when(() => useCase(groupId: any(named: 'groupId')))
//             .thenAnswer((_) async => const Left(ServerFailure('x')));
//         final cubit = GetBannedMembersCubit(getGroupBannedMembersUseCase: useCase);
//         final types = await _captureStateTypes(
//           cubit.stream,
//           () => cubit.getBannedMembers(groupId: 'g'),
//         );
//         expect(types, ['GetBannedMembersLoading', 'GetBannedMembersFailure']);
//         await cubit.close();
//       },
//     );

//     test('Unit Test - GetGroupCubit emits [Loading, Failure] on failed use case', () async {
//       final useCase = MockGetGroupUseCase();
//       when(() => useCase(groupId: any(named: 'groupId')))
//           .thenAnswer((_) async => const Left(ServerFailure('x')));
//       final cubit = GetGroupCubit(getGroupUseCase: useCase);
//       final types = await _captureStateTypes(cubit.stream, () => cubit.getGroup('g'));
//       expect(types, ['GetGroupLoading', 'GetGroupFailure']);
//       await cubit.close();
//     });

//     test(
//       'Unit Test - GetAllGroupsCubit updates local cache/list correctly',
//       () async {
//         final useCase = MockGetAllGroupsUseCase();
//         when(
//           () => useCase(page: any(named: 'page'), search: any(named: 'search')),
//         ).thenAnswer(
//           (_) async => const Right(
//             <Group>[
//               Group(groupId: 'g1', groupName: 'A'),
//               Group(groupId: 'g2', groupName: 'B'),
//             ],
//           ),
//         );
//         final cubit = GetAllGroupsCubit(getAllGroupsUseCase: useCase);
//         final g2 = const Group(groupId: 'g2', groupName: 'B');
//         await cubit.getAllGroups();
//         cubit.removeGroupLocally('g1');
//         final state = cubit.state as GetGroupsSuccess;
//         expect(state.groups, [g2]);
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - GetGroupsPostsFeedCubit emits [Loading, Failure] on failed use case',
//       () async {
//         final useCase = MockGetGroupsPostsFeedUseCase();
//         when(() => useCase(page: any(named: 'page')))
//             .thenAnswer((_) async => const Left(ServerFailure('x')));
//         final cubit = GetGroupsPostsFeedCubit(getGroupsPostsFeedUseCase: useCase);
//         final types = await _captureStateTypes(
//           cubit.stream,
//           () => cubit.fetchFeed(isRefresh: true),
//         );
//         expect(types, ['GetGroupsPostsFeedLoading', 'GetGroupsPostsFeedError']);
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - GetJoinedGroupsCubit emits [Loading, Failure] on failed use case',
//       () async {
//         final useCase = MockGetJoinedGroupsUseCase();
//         when(
//           () => useCase(page: any(named: 'page'), search: any(named: 'search')),
//         ).thenAnswer((_) async => const Left(ServerFailure('x')));
//         final cubit = GetJoinedGroupsCubit(getJoinedGroupsUseCase: useCase);
//         final types = await _captureStateTypes(cubit.stream, cubit.getJoinedGroups);
//         expect(types, ['GetJoinedGroupsLoading', 'GetJoinedGroupsFailure']);
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - GetJoinRequestsCubit emits [Loading, Failure] on failed use case',
//       () async {
//         final useCase = MockGetJoinRequestsUseCase();
//         when(() => useCase(groupId: any(named: 'groupId')))
//             .thenAnswer((_) async => const Left(ValidationFailure('x')));
//         final cubit = GetJoinRequestsCubit(getJoinRequestsUseCase: useCase);
//         final types = await _captureStateTypes(
//           cubit.stream,
//           () => cubit.getJoinRequestsGroup(groupId: 'g'),
//         );
//         expect(types, ['GetJoinRequestsLoading', 'GetJoinRequestsFailure']);
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - GroupMembersCubit updates local cache/list correctly',
//       () async {
//         final membersUseCase = MockGetGroupMembersUseCase();
//         final moderatorsUseCase = MockGetGroupModeratorsUseCase();
//         final adminsUseCase = MockGetGroupAdminsUseCase();
//         when(() => membersUseCase(groupId: any(named: 'groupId')))
//             .thenAnswer((_) async => const Right(<GroupMember>[]));
//         when(() => moderatorsUseCase(groupId: any(named: 'groupId')))
//             .thenAnswer((_) async => const Right(<GroupMember>[]));
//         when(() => adminsUseCase(groupId: any(named: 'groupId')))
//             .thenAnswer((_) async => const Right(<GroupMember>[]));

//         final cubit = GroupMembersCubit(membersUseCase, moderatorsUseCase, adminsUseCase);
//         when(() => membersUseCase(groupId: any(named: 'groupId'))).thenAnswer(
//           (_) async => const Right(<GroupMember>[GroupMember(userId: 'u1', role: 'member')]),
//         );
//         await cubit.getAllGroupData('g');
//         cubit.updateMemberRoleLocally('u1', 'moderator');
//         final state = cubit.state;
//         expect(state.runtimeType.toString(), 'GroupMembersState');
//         expect(state.members.where((m) => m.userId == 'u1'), isEmpty);
//         expect(state.moderators.any((m) => m.userId == 'u1'), isTrue);
//         await cubit.close();
//       },
//     );

//     test(
//       'Unit Test - GetMyGroupsCubit emits [Loading, Failure] on failed use case',
//       () async {
//         final useCase = MockGetMyGroupsUseCase();
//         when(
//           () => useCase(page: any(named: 'page'), search: any(named: 'search')),
//         ).thenAnswer((_) async => const Left(ServerFailure('x')));
//         final cubit = GetMyGroupsCubit(getMyGroupsUseCase: useCase);
//         final types = await _captureStateTypes(cubit.stream, cubit.getMyGroups);
//         expect(types, ['GetMyGroupsLoading', 'GetMyGroupsFailure']);
//         await cubit.close();
//       },
//     );

//     test('Unit Test - JoinGroupCubit emits [Loading, Failure] on failed use case', () async {
//       final useCase = MockJoinGroupUseCase();
//       when(() => useCase(groupId: any(named: 'groupId')))
//           .thenAnswer((_) async => const Left(NetworkFailure('x')));
//       final cubit = JoinGroupCubit(joinGroupUseCase: useCase);
//       final types = await _captureStateTypes(
//         cubit.stream,
//         () => cubit.joinGroup(groupId: 'g'),
//       );
//       expect(types, ['JoinGroupLoading', 'JoinGroupFailure']);
//       await cubit.close();
//     });

//     test('Unit Test - KickMemberCubit emits [Loading, Failure] on failed use case', () async {
//       final useCase = MockKickMemberUseCase();
//       when(
//         () => useCase(groupId: any(named: 'groupId'), userId: any(named: 'userId')),
//       ).thenAnswer((_) async => const Left(ServerFailure('x')));
//       final cubit = KickMemberCubit(kickMemberUseCase: useCase);
//       final types = await _captureStateTypes(
//         cubit.stream,
//         () => cubit.kickMember(groupId: 'g', targetUserId: 'u'),
//       );
//       expect(types, ['KickMemberLoading', 'KickMemberFailure']);
//       await cubit.close();
//     });

//     test('Unit Test - LeaveGroupCubit emits [Loading, Failure] on failed use case', () async {
//       final useCase = MockLeaveGroupUseCase();
//       when(() => useCase(groupId: any(named: 'groupId')))
//           .thenAnswer((_) async => const Left(ServerFailure('x')));
//       final cubit = LeaveGroupCubit(leaveGroupUseCase: useCase);
//       final types = await _captureStateTypes(
//         cubit.stream,
//         () => cubit.leaveGroup(groupId: 'g'),
//       );
//       expect(types, ['LeaveGroupLoading', 'LeaveGroupFailure']);
//       await cubit.close();
//     });

//     test('Unit Test - UnbanMemberCubit emits [Loading, Failure] on failed use case', () async {
//       final useCase = MockUnbanMemberUseCase();
//       when(
//         () => useCase(groupId: any(named: 'groupId'), userId: any(named: 'userId')),
//       ).thenAnswer((_) async => const Left(ServerFailure('x')));
//       final cubit = UnbanMemberCubit(unbanMemberUseCase: useCase);
//       final types = await _captureStateTypes(
//         cubit.stream,
//         () => cubit.unbanMember(groupId: 'g', targetUserId: 'u'),
//       );
//       expect(types, ['UnbanMemberLoading', 'UnbanMemberFailure']);
//       await cubit.close();
//     });

//     test('Unit Test - UpdateGroupCubit emits [Loading, Failure] on failed use case', () async {
//       final useCase = MockUpdateGroupUseCase();
//       when(
//         () => useCase(
//           groupId: any(named: 'groupId'),
//           name: any(named: 'name'),
//           description: any(named: 'description'),
//           coverImage: any(named: 'coverImage'),
//         ),
//       ).thenAnswer((_) async => const Left(ServerFailure('x')));
//       final cubit = UpdateGroupCubit(updateGroupUseCase: useCase);
//       final types = await _captureStateTypes(
//         cubit.stream,
//         () => cubit.updateGroup(groupId: 'g'),
//       );
//       expect(types, ['UpdateGroupLoading', 'UpdateGroupFailure']);
//       await cubit.close();
//     });

//     test('Unit Test - LocaleCubit updates local state when toggled', () async {
//       final cubit = LocaleCubit();
//       await Future<void>.delayed(const Duration(milliseconds: 30));
//       final before = cubit.state.languageCode;
//       cubit.toggleLocale();
//       await Future<void>.delayed(const Duration(milliseconds: 20));
//       final after = cubit.state.languageCode;
//       expect(before == 'en' ? 'ar' : 'en', after);
//       await cubit.close();
//     });

//     test('Unit Test - CreatePostCubit emits [Loading, Failure] on failed use case', () async {
//       final createPost = MockCreatePostUseCase();
//       when(
//         () => createPost(
//           caption: any(named: 'caption'),
//           media: any(named: 'media'),
//           type: any(named: 'type'),
//         ),
//       ).thenAnswer((_) async => const Left(ValidationFailure('x')));
//       final cubit = CreatePostCubit(
//         createPostUseCase: createPost,
//         createGroupPostUseCase: MockCreateGroupPostUseCase(),
//       );
//       cubit.updateText('hi');
//       final types = await _captureStateTypes(
//         cubit.stream,
//         () => cubit.submitPost(userId: 'u1'),
//       );
//       expect(types.contains('CreatePostLoading'), isTrue);
//       expect(types.contains('CreatePostError'), isTrue);
//       await cubit.close();
//     });

//     test('Unit Test - GetPostCubit emits [Loading, Failure] on failed use case', () async {
//       final useCase = MockGetPostUseCase();
//       when(() => useCase(any())).thenAnswer((_) async => const Left(ServerFailure('x')));
//       final cubit = GetPostCubit(getPostUseCase: useCase);
//       final types = await _captureStateTypes(cubit.stream, () => cubit.getPost('p1'));
//       expect(types, ['GetPostLoading', 'GetPostFailure']);
//       await cubit.close();
//     });

//     test(
//       'Unit Test - PostInteractionCubit emits [Loading, Failure] on failed use case',
//       () async {
//         final reportUseCase = MockReportPostUseCase();
//         when(
//           () => reportUseCase(
//             postId: any(named: 'postId'),
//             userId: any(named: 'userId'),
//             reason: any(named: 'reason'),
//           ),
//         ).thenAnswer((_) async => const Left(ServerFailure('x')));
//         final cubit = PostInteractionCubit(
//           reactToPostUseCase: MockReactToPostUseCase(),
//           removeReactionFromPostUseCase: MockRemoveReactionFromPostUseCase(),
//           commentOnPostUseCase: MockCommentOnPostUseCase(),
//           reportPostUseCase: reportUseCase,
//           sharePostUseCase: MockSharePostUseCase(),
//           toggleSavePostUseCase: MockSavePostUseCase(),
//           followUserUseCase: MockFollowUserUseCase(),
//         );
//         final types = await _captureStateTypes(
//           cubit.stream,
//           () => cubit.reportPost(postId: 'p', userId: 'u', reason: 'r'),
//         );
//         expect(types, ['ReportPostLoading', 'ReportPostError']);
//         await cubit.close();
//       },
//     );

//     test('Unit Test - ProfileCubit emits [Loading, Failure] on failed use case', () async {
//       final useCase = MockGetMyProfile();
//       when(() => useCase()).thenAnswer((_) async => const Left(ServerFailure('x')));
//       final cubit = ProfileCubit(getMyProfile: useCase);
//       final types = await _captureStateTypes(cubit.stream, cubit.loadProfile);
//       expect(types, ['ProfileLoading', 'ProfileError']);
//       await cubit.close();
//     });

//     test('Unit Test - VerifyCodeCubit emits validation error on invalid code', () async {
//       final cubit = VerifyCodeCubit(
//         username: 'u',
//         email: 'u@mail.com',
//         verifyCode: MockVerifyCode(),
//         resendVerificationCode: MockResendVerificationCode(),
//       );
//       final types = await _captureStateTypes(cubit.stream, () => cubit.verify('123'));
//       expect(types, ['VerifyCodeError']);
//       await cubit.close();
//     });

//     test(
//       'Unit Test - ForgetPasswordOTPCubit emits [Loading, Failure] on failed use case',
//       () async {
//         final useCase = MockVerifyOTP();
//         when(
//           () => useCase(
//             otp: any(named: 'otp'),
//             email: any(named: 'email'),
//             password: any(named: 'password'),
//             confirmPassword: any(named: 'confirmPassword'),
//           ),
//         ).thenAnswer((_) async => const Left(ServerFailure('x')));
//         final cubit = ForgetPasswordOTPCubit(verifyOTP: useCase);
//         final types = await _captureStateTypes(
//           cubit.stream,
//           () => cubit.verifyOtp('123456', 'u@mail.com', '12345678', '12345678'),
//           settle: const Duration(milliseconds: 2200),
//         );
//         expect(types.first, 'ForgetPasswordOTPLoading');
//         expect(types.last, 'ForgetPasswordOTPFailure');
//         await cubit.close();
//       },
//     );

//     test('Unit Test - RequestOTPCubit emits failure on invalid email', () async {
//       final cubit = RequestOTPCubit(sendPasswordResetOtp: MockSendPasswordResetOtp());
//       final types = await _captureStateTypes(
//         cubit.stream,
//         () => cubit.sendOtp('invalid'),
//       );
//       expect(types, ['RequestOTPFailure']);
//       await cubit.close();
//     });

//     test('Unit Test - StatsCubit emits [Loading, Failure] on failed use case', () async {
//       final useCase = MockStatsUseCase();
//       when(() => useCase()).thenAnswer((_) async => const Left(ServerFailure('x')));
//       final cubit = StatsCubit(useCase);
//       final types = await _captureStateTypes(cubit.stream, cubit.loadStats);
//       expect(types, ['StatsLoading', 'StatsError']);
//       await cubit.close();
//     });

//     test('Unit Test - ThemeCubit updates local state when toggled', () async {
//       final prefs = MockSharedPreferences();
//       when(() => prefs.getString(any())).thenReturn('light');
//       when(() => prefs.setString(any(), any())).thenAnswer((_) async => true);
//       final cubit = ThemeCubit(prefs);
//       final types = await _captureStateTypes(
//         cubit.stream,
//         () async => cubit.toggleTheme(),
//         settle: const Duration(milliseconds: 520),
//       );
//       expect(types, ['ThemeState', 'ThemeState', 'ThemeState']);
//       expect(cubit.state.mode, ThemeMode.dark);
//       await cubit.close();
//     });

//     test('Unit Test - Smoke Test - helper cubits still initialize with initial states', () async {
//       final p = Post(type: 'text', postID: 'p1', reactionsCount: 0, commentsCount: 0, userReaction: ReactionType.none);
//       expect(p.postID, 'p1');
//     });
//   });
// }
