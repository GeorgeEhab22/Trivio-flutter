// import 'package:auth/domain/usecases/comment/add_comment_usecase.dart';
// import 'package:auth/domain/usecases/comment/delete_comment_usecase.dart';
// import 'package:auth/domain/usecases/comment/edit_comment_usecase.dart';
// import 'package:auth/domain/usecases/comment/get_comments_usecase.dart';
// import 'package:auth/domain/usecases/comment/get_replies_usecase.dart';
// import 'package:auth/domain/usecases/comment/mention_users_in_comment_usecase.dart';
// import 'package:auth/domain/usecases/comment/react_to_comment_usecase.dart';
// import 'package:auth/domain/usecases/comment/remove_reaction_from_comment_usecase.dart';
// import 'package:auth/domain/usecases/group/accept_join_request_use_case.dart';
// import 'package:auth/domain/usecases/group/cancel_request_use_case.dart';
// import 'package:auth/domain/usecases/group/decline_join_request_use_case.dart';
// import 'package:auth/domain/usecases/group/get_join_requests_use_case.dart';
// import 'package:auth/domain/usecases/group/group_posts/create_group_post_use_case.dart';
// import 'package:auth/domain/usecases/group/group_posts/delete_group_post_use_case.dart';
// import 'package:auth/domain/usecases/group/group_posts/get_group_posts_use_case.dart';
// import 'package:auth/domain/usecases/group/group_posts/get_groups_posts_feed_use_case.dart';
// import 'package:auth/domain/usecases/group/groups/create_group_use_case.dart';
// import 'package:auth/domain/usecases/group/groups/delete_group_use_case.dart';
// import 'package:auth/domain/usecases/group/groups/edit_group_use_case.dart';
// import 'package:auth/domain/usecases/group/groups/get_group_use_case.dart';
// import 'package:auth/domain/usecases/group/groups/get_groups_use_case.dart';
// import 'package:auth/domain/usecases/group/groups/get_joined_groups_use_case.dart';
// import 'package:auth/domain/usecases/group/groups/get_my_groups_use_case.dart';
// import 'package:auth/domain/usecases/group/groups/join_group_use_case.dart';
// import 'package:auth/domain/usecases/group/groups/leave_group_use_case.dart';
// import 'package:auth/domain/usecases/group/members/ban_member_use_case.dart';
// import 'package:auth/domain/usecases/group/members/change_member_rule_use_case.dart';
// import 'package:auth/domain/usecases/group/members/get_group_admins_use_case.dart';
// import 'package:auth/domain/usecases/group/members/get_group_banned_members_use_case.dart';
// import 'package:auth/domain/usecases/group/members/get_group_members_use_case.dart';
// import 'package:auth/domain/usecases/group/members/get_group_moderators_use_case.dart';
// import 'package:auth/domain/usecases/group/members/kick_member_use_case.dart';
// import 'package:auth/domain/usecases/group/members/unban_member_use_case.dart';
// import 'package:auth/domain/usecases/post/comment_on_post_usecase.dart';
// import 'package:auth/domain/usecases/post/create_post_usecase.dart';
// import 'package:auth/domain/usecases/post/delete_post_usecase.dart';
// import 'package:auth/domain/usecases/post/edit_post_usecase.dart';
// import 'package:auth/domain/usecases/post/follow_user.dart';
// import 'package:auth/domain/usecases/post/get_post_usecase.dart';
// import 'package:auth/domain/usecases/post/get_posts_usecase.dart';
// import 'package:auth/domain/usecases/post/react_to_post_usecase.dart';
// import 'package:auth/domain/usecases/post/remove_reaction_from_post_usecase.dart';
// import 'package:auth/domain/usecases/post/report_post_usecase.dart';
// import 'package:auth/domain/usecases/post/save_post_usecase.dart';
// import 'package:auth/domain/usecases/post/share_post_usecase.dart';
// import 'package:auth/domain/usecases/register/register_usecase.dart';
// import 'package:auth/domain/usecases/register/resend_verification_code.dart';
// import 'package:auth/domain/usecases/register/verify_code.dart';
// import 'package:auth/domain/usecases/sign_in/google_sign_in_and_rigester_usecases.dart';
// import 'package:auth/domain/usecases/sign_in/request_otp.dart';
// import 'package:auth/domain/usecases/sign_in/signin_usecase.dart';
// import 'package:auth/domain/usecases/sign_in/verify_otp.dart';
// import 'package:auth/domain/usecases/stats/stats_usecase.dart';
// import 'package:auth/domain/usecases/user_profile/get_my_profile.dart';
// import 'package:auth/presentation/manager/comment_cubit/comment_cubit.dart';
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
// import 'package:auth/presentation/manager/group_cubit/get_group_posts/group_posts_cubit.dart';
// import 'package:auth/presentation/manager/group_cubit/get_groups/get_groups_cubit.dart';
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
// import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
// import 'package:auth/presentation/manager/post_cubit/post_interaction_cubit.dart';
// import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
// import 'package:auth/presentation/manager/register_cubit/register_cubit.dart';
// import 'package:auth/presentation/manager/register_cubit/verify_code_cubit.dart';
// import 'package:auth/presentation/manager/sigin_in_cubit/forget_password_otp_cubit.dart';
// import 'package:auth/presentation/manager/sigin_in_cubit/request_otp/request_otp_cubit.dart';
// import 'package:auth/presentation/manager/sigin_in_cubit/sign_in_cubit.dart';
// import 'package:auth/presentation/manager/stats_cubit/stats_cubit.dart';
// import 'package:auth/presentation/manager/theme_cubit/theme_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MockGetCommentsUseCase extends Mock implements GetCommentsUseCase {}
// class MockGetCommentUseCase extends Mock implements GetCommentUseCase {}
// class MockGetCommentReactionsUseCase extends Mock
//     implements GetCommentReactionsUseCase {}
// class MockAddCommentUseCase extends Mock implements AddCommentUseCase {}
// class MockDeleteCommentUseCase extends Mock implements DeleteCommentUseCase {}
// class MockEditCommentUseCase extends Mock implements EditCommentUseCase {}
// class MockGetRepliesUseCase extends Mock implements GetRepliesUseCase {}
// class MockMentionUsersInCommentUseCase extends Mock
//     implements MentionUsersInCommentUseCase {}
// class MockReactToCommentUseCase extends Mock implements ReactToCommentUseCase {}
// class MockRemoveReactionFromCommentUseCase extends Mock
//     implements RemoveReactionFromCommentUseCase {}
// class MockAcceptJoinRequestUseCase extends Mock
//     implements AcceptJoinRequestUseCase {}
// class MockBanMemberUseCase extends Mock implements BanMemberUseCase {}
// class MockCancelRequestUseCase extends Mock implements CancelRequestUseCase {}
// class MockChangeMemberRoleUseCase extends Mock
//     implements ChangeMemberRoleUseCase {}
// class MockCreateGroupUseCase extends Mock implements CreateGroupUseCase {}
// class MockDeclineJoinRequestUseCase extends Mock
//     implements DeclineJoinRequestUseCase {}
// class MockDeleteGroupUseCase extends Mock implements DeleteGroupUseCase {}
// class MockGetGroupBannedMembersUseCase extends Mock
//     implements GetGroupBannedMembersUseCase {}
// class MockGetGroupUseCase extends Mock implements GetGroupUseCase {}
// class MockGetAllGroupsUseCase extends Mock implements GetAllGroupsUseCase {}
// class MockGetGroupsPostsFeedUseCase extends Mock
//     implements GetGroupsPostsFeedUseCase {}
// class MockGetGroupPostsUseCase extends Mock implements GetGroupPostsUseCase {}
// class MockDeleteGroupPostUseCase extends Mock
//     implements DeleteGroupPostUseCase {}
// class MockGetJoinedGroupsUseCase extends Mock
//     implements GetJoinedGroupsUseCase {}
// class MockGetJoinRequestsUseCase extends Mock implements GetJoinRequestsUseCase {}
// class MockGetGroupMembersUseCase extends Mock implements GetGroupMembersUseCase {}
// class MockGetGroupModeratorsUseCase extends Mock
//     implements GetGroupModeratorsUseCase {}
// class MockGetGroupAdminsUseCase extends Mock implements GetGroupAdminsUseCase {}
// class MockGetMyGroupsUseCase extends Mock implements GetMyGroupsUseCase {}
// class MockJoinGroupUseCase extends Mock implements JoinGroupUseCase {}
// class MockKickMemberUseCase extends Mock implements KickMemberUseCase {}
// class MockLeaveGroupUseCase extends Mock implements LeaveGroupUseCase {}
// class MockUnbanMemberUseCase extends Mock implements UnbanMemberUseCase {}
// class MockUpdateGroupUseCase extends Mock implements UpdateGroupUseCase {}
// class MockCreatePostUseCase extends Mock implements CreatePostUseCase {}
// class MockCreateGroupPostUseCase extends Mock implements CreateGroupPostUseCase {}
// class MockGetPostsUseCase extends Mock implements GetPostsUseCase {}
// class MockGetPostReactionsUseCase extends Mock
//     implements GetPostReactionsUseCase {}
// class MockDeletePostUseCase extends Mock implements DeletePostUseCase {}
// class MockEditPostUseCase extends Mock implements EditPostUseCase {}
// class MockReactToPostUseCase extends Mock implements ReactToPostUseCase {}
// class MockRemoveReactionFromPostUseCase extends Mock
//     implements RemoveReactionFromPostUseCase {}
// class MockCommentOnPostUseCase extends Mock implements CommentOnPostUseCase {}
// class MockReportPostUseCase extends Mock implements ReportPostUseCase {}
// class MockSharePostUseCase extends Mock implements SharePostUseCase {}
// class MockSavePostUseCase extends Mock implements SavePostUseCase {}
// class MockFollowUserUseCase extends Mock implements FollowUserUseCase {}
// class MockGetPostUseCase extends Mock implements GetPostUseCase {}
// class MockGetMyProfile extends Mock implements GetMyProfile {}
// class MockRegisterUseCase extends Mock implements RegisterUseCase {}
// class MockVerifyCode extends Mock implements VerifyCode {}
// class MockResendVerificationCode extends Mock
//     implements ResendVerificationCode {}
// class MockVerifyOTP extends Mock implements VerifyOTP {}
// class MockSignInUseCase extends Mock implements SignInUseCase {}
// class MockGoogleSignInAndRegisterUseCase extends Mock
//     implements GoogleSignInAndRegisterUseCase {}
// class MockSendPasswordResetOtp extends Mock implements SendPasswordResetOtp {}
// class MockStatsUseCase extends Mock implements StatsUseCase {}
// class MockSharedPreferences extends Mock implements SharedPreferences {}

// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();

//   setUpAll(() async {
//     SharedPreferences.setMockInitialValues(<String, Object>{});
//   });

//   group('Non-follow cubits', () {
//     test('CommentCubit starts with CommentInitial', () async {
//       final cubit = CommentCubit(
//         getCommentsUseCase: MockGetCommentsUseCase(),
//         getCommentUseCase: MockGetCommentUseCase(),
//         getCommentReactionsUseCase: MockGetCommentReactionsUseCase(),
//         addCommentUseCase: MockAddCommentUseCase(),
//         deleteCommentUseCase: MockDeleteCommentUseCase(),
//         editCommentUseCase: MockEditCommentUseCase(),
//         getRepliesUseCase: MockGetRepliesUseCase(),
//         mentionUsersInCommentUseCase: MockMentionUsersInCommentUseCase(),
//         reactToCommentUseCase: MockReactToCommentUseCase(),
//         removeReactionFromCommentUseCase: MockRemoveReactionFromCommentUseCase(),
//       );
//       expect(cubit.state.runtimeType.toString(), 'CommentInitial');
//       await cubit.close();
//     });

//     test('Group cubits start with initial states', () async {
//       final accept = AcceptRequestCubit(
//         acceptJoinRequestUseCase: MockAcceptJoinRequestUseCase(),
//       );
//       final ban = BanMemberCubit(banMemberUseCase: MockBanMemberUseCase());
//       final cancel = CancelRequestGroupCubit(
//         cancelRequestUseCase: MockCancelRequestUseCase(),
//       );
//       final changeRole = ChangeMemberRoleCubit(
//         changeMemberRoleUseCase: MockChangeMemberRoleUseCase(),
//       );
//       final create = CreateGroupCubit(createGroupUseCase: MockCreateGroupUseCase());
//       final decline = DeclineRequestCubit(
//         declineJoinRequestUseCase: MockDeclineJoinRequestUseCase(),
//       );
//       final delete = DeleteGroupCubit(deleteGroupUseCase: MockDeleteGroupUseCase());
//       final banned = GetBannedMembersCubit(
//         getGroupBannedMembersUseCase: MockGetGroupBannedMembersUseCase(),
//       );
//       final getGroup = GetGroupCubit(getGroupUseCase: MockGetGroupUseCase());
//       final getGroups = GetAllGroupsCubit(getAllGroupsUseCase: MockGetAllGroupsUseCase());
//       final feed = GetGroupsPostsFeedCubit(
//         getGroupsPostsFeedUseCase: MockGetGroupsPostsFeedUseCase(),
//       );
//       final posts = GroupPostsCubit(
//         getGroupPostsUseCase: MockGetGroupPostsUseCase(),
//         deleteGroupPostUseCase: MockDeleteGroupPostUseCase(),
//       );
//       final joined = GetJoinedGroupsCubit(
//         getJoinedGroupsUseCase: MockGetJoinedGroupsUseCase(),
//       );
//       final joinRequests = GetJoinRequestsCubit(
//         getJoinRequestsUseCase: MockGetJoinRequestsUseCase(),
//       );
//       final members = GroupMembersCubit(
//         MockGetGroupMembersUseCase(),
//         MockGetGroupModeratorsUseCase(),
//         MockGetGroupAdminsUseCase(),
//       );
//       final myGroups = GetMyGroupsCubit(getMyGroupsUseCase: MockGetMyGroupsUseCase());
//       final join = JoinGroupCubit(joinGroupUseCase: MockJoinGroupUseCase());
//       final kick = KickMemberCubit(kickMemberUseCase: MockKickMemberUseCase());
//       final leave = LeaveGroupCubit(leaveGroupUseCase: MockLeaveGroupUseCase());
//       final unban = UnbanMemberCubit(unbanMemberUseCase: MockUnbanMemberUseCase());
//       final update = UpdateGroupCubit(updateGroupUseCase: MockUpdateGroupUseCase());

//       expect(accept.state.runtimeType.toString(), 'AcceptRequestInitial');
//       expect(ban.state.runtimeType.toString(), 'BanMemberInitial');
//       expect(cancel.state.runtimeType.toString(), 'CancelRequestGroupInitial');
//       expect(changeRole.state.runtimeType.toString(), 'ChangeMemberRoleInitial');
//       expect(create.state.runtimeType.toString(), 'CreateGroupInitial');
//       expect(decline.state.runtimeType.toString(), 'DeclineRequestInitial');
//       expect(delete.state.runtimeType.toString(), 'DeleteGroupInitial');
//       expect(banned.state.runtimeType.toString(), 'GetBannedMembersInitial');
//       expect(getGroup.state.runtimeType.toString(), 'GetGroupInitial');
//       expect(getGroups.state.runtimeType.toString(), 'GetGroupsInitial');
//       expect(feed.state.runtimeType.toString(), 'GetGroupsPostsFeedInitial');
//       expect(posts.state.runtimeType.toString(), 'GroupPostsInitial');
//       expect(joined.state.runtimeType.toString(), 'GetJoinedGroupsInitial');
//       expect(joinRequests.state.runtimeType.toString(), 'GetJoinRequestsInitial');
//       expect(members.state.runtimeType.toString(), 'GroupMembersState');
//       expect(myGroups.state.runtimeType.toString(), 'GetMyGroupsInitial');
//       expect(join.state.runtimeType.toString(), 'JoinGroupInitial');
//       expect(kick.state.runtimeType.toString(), 'KickMemberInitial');
//       expect(leave.state.runtimeType.toString(), 'LeaveGroupInitial');
//       expect(unban.state.runtimeType.toString(), 'UnbanMemberInitial');
//       expect(update.state.runtimeType.toString(), 'UpdateGroupInitial');

//       await accept.close();
//       await ban.close();
//       await cancel.close();
//       await changeRole.close();
//       await create.close();
//       await decline.close();
//       await delete.close();
//       await banned.close();
//       await getGroup.close();
//       await getGroups.close();
//       await feed.close();
//       await posts.close();
//       await joined.close();
//       await joinRequests.close();
//       await members.close();
//       await myGroups.close();
//       await join.close();
//       await kick.close();
//       await leave.close();
//       await unban.close();
//       await update.close();
//     });

//     test('LocaleCubit starts with en locale', () async {
//       final cubit = LocaleCubit();
//       expect(cubit.state.languageCode, 'en');
//       await Future<void>.delayed(const Duration(milliseconds: 20));
//       await cubit.close();
//     });

//     test('Post cubits start with initial states', () async {
//       final prefs = MockSharedPreferences();
//       when(() => prefs.getString(any())).thenReturn(null);

//       final create = CreatePostCubit(
//         createPostUseCase: MockCreatePostUseCase(),
//         createGroupPostUseCase: MockCreateGroupPostUseCase(),
//       );
//       final post = PostCubit(
//         getPostsUseCase: MockGetPostsUseCase(),
//         getPostReactionsUseCase: MockGetPostReactionsUseCase(),
//         deletePostUseCase: MockDeletePostUseCase(),
//         editPostUseCase: MockEditPostUseCase(),
//         prefs: prefs,
//       );
//       final interaction = PostInteractionCubit(
//         reactToPostUseCase: MockReactToPostUseCase(),
//         removeReactionFromPostUseCase: MockRemoveReactionFromPostUseCase(),
//         commentOnPostUseCase: MockCommentOnPostUseCase(),
//         reportPostUseCase: MockReportPostUseCase(),
//         sharePostUseCase: MockSharePostUseCase(),
//         toggleSavePostUseCase: MockSavePostUseCase(),
//         followUserUseCase: MockFollowUserUseCase(),
//       );
//       final getPost = GetPostCubit(getPostUseCase: MockGetPostUseCase());

//       expect(create.state.runtimeType.toString(), 'CreatePostInitial');
//       expect(post.state.runtimeType.toString(), 'PostInitial');
//       expect(interaction.state.runtimeType.toString(), 'PostInteractionInitial');
//       expect(getPost.state.runtimeType.toString(), 'GetPostInitial');

//       await create.close();
//       await post.close();
//       await interaction.close();
//       await getPost.close();
//     });

//     test('Auth/profile/stats/theme cubits start with initial states', () async {
//       final prefs = MockSharedPreferences();
//       when(() => prefs.getString(any())).thenReturn('system');

//       final profile = ProfileCubit(getMyProfile: MockGetMyProfile());
//       final register = RegisterCubit(registerUseCase: MockRegisterUseCase());
//       final verify = VerifyCodeCubit(
//         username: 'u',
//         email: 'u@test.com',
//         verifyCode: MockVerifyCode(),
//         resendVerificationCode: MockResendVerificationCode(),
//       );
//       final forget = ForgetPasswordOTPCubit(verifyOTP: MockVerifyOTP());
//       final signIn = SignInCubit(
//         signInUseCase: MockSignInUseCase(),
//         googleSignInUseCase: MockGoogleSignInAndRegisterUseCase(),
//       );
//       final requestOtp = RequestOTPCubit(sendPasswordResetOtp: MockSendPasswordResetOtp());
//       final stats = StatsCubit(MockStatsUseCase());
//       final theme = ThemeCubit(prefs);

//       expect(profile.state.runtimeType.toString(), 'ProfileInitial');
//       expect(register.state.runtimeType.toString(), 'RegisterInitial');
//       expect(verify.state.runtimeType.toString(), 'VerifyCodeInitial');
//       expect(forget.state.runtimeType.toString(), 'ForgetPasswordOTPInitial');
//       expect(signIn.state.runtimeType.toString(), 'SignInInitial');
//       expect(requestOtp.state.runtimeType.toString(), 'RequestOTPInitial');
//       expect(stats.state.runtimeType.toString(), 'StatsInitial');
//       expect(theme.state.mode, ThemeMode.system);

//       await profile.close();
//       await register.close();
//       await verify.close();
//       await forget.close();
//       await signIn.close();
//       await requestOtp.close();
//       await stats.close();
//       await theme.close();
//     });
//   });
// }
