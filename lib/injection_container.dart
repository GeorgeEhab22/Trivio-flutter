import 'dart:io';

import 'package:auth/common/api_service.dart';
import 'package:auth/common/functions/handle_dio_error.dart';
import 'package:auth/data/datasource/auth_remote_datasource.dart';
import 'package:auth/data/datasource/comments_remote_datasource.dart';
import 'package:auth/data/datasource/groups_remote_datasource.dart';
import 'package:auth/data/datasource/posts_remote_datasource.dart';
import 'package:auth/data/datasource/stats_local_datasource.dart';
import 'package:auth/data/datasource/stats_remote_datasource.dart';
import 'package:auth/data/repositories/auth_repo_impl.dart';
import 'package:auth/data/repositories/comment_repo_impl.dart';
import 'package:auth/data/repositories/group_repo_impl.dart';
import 'package:auth/data/repositories/post_repo_impl.dart';
import 'package:auth/data/repositories/stats_repo_impl.dart';
import 'package:auth/domain/repositories/auth_repo.dart';
import 'package:auth/domain/repositories/comment_repo.dart';
import 'package:auth/domain/repositories/group_repo.dart';
import 'package:auth/domain/repositories/post_repo.dart';
import 'package:auth/domain/repositories/stats_repo.dart';
import 'package:auth/data/datasource/follow_remote_datasource.dart';
import 'package:auth/data/datasource/profile_remote_datasource.dart';
import 'package:auth/data/repositories/follow_repo_impl.dart';
import 'package:auth/data/repositories/profile_repo_impl.dart';
import 'package:auth/domain/repositories/follow_repo.dart';
import 'package:auth/domain/repositories/user_profile_repo.dart';
import 'package:auth/domain/usecases/comment/add_comment_usecase.dart';
import 'package:auth/domain/usecases/comment/delete_comment_usecase.dart';
import 'package:auth/domain/usecases/comment/edit_comment_usecase.dart';
import 'package:auth/domain/usecases/comment/get_comments_usecase.dart';
import 'package:auth/domain/usecases/comment/get_replies_usecase.dart';
import 'package:auth/domain/usecases/comment/mention_users_in_comment_usecase.dart';
import 'package:auth/domain/usecases/comment/react_to_comment_usecase.dart';
import 'package:auth/domain/usecases/group/accept_join_request_use_case.dart';
import 'package:auth/domain/usecases/group/cancel_request_use_case.dart';
import 'package:auth/domain/usecases/group/decline_join_request_use_case.dart';
import 'package:auth/domain/usecases/group/get_join_requests_use_case.dart';
import 'package:auth/domain/usecases/group/group_posts/create_group_post_use_case.dart';
import 'package:auth/domain/usecases/group/group_posts/delete_group_post_use_case.dart';
import 'package:auth/domain/usecases/group/group_posts/get_group_posts_use_case.dart';
import 'package:auth/domain/usecases/group/group_posts/get_groups_posts_feed_use_case.dart';
import 'package:auth/domain/usecases/group/groups/create_group_use_case.dart';
import 'package:auth/domain/usecases/group/groups/delete_group_use_case.dart';
import 'package:auth/domain/usecases/group/groups/edit_group_use_case.dart';
import 'package:auth/domain/usecases/group/groups/get_group_use_case.dart';
import 'package:auth/domain/usecases/group/groups/get_groups_use_case.dart';
import 'package:auth/domain/usecases/group/groups/get_joined_groups_use_case.dart';
import 'package:auth/domain/usecases/group/groups/get_my_groups_use_case.dart';
import 'package:auth/domain/usecases/group/groups/join_group_use_case.dart';
import 'package:auth/domain/usecases/group/groups/leave_group_use_case.dart';
import 'package:auth/domain/usecases/group/members/ban_member_use_case.dart';
import 'package:auth/domain/usecases/group/members/change_member_rule_use_case.dart';
import 'package:auth/domain/usecases/group/members/get_group_admins_use_case.dart';
import 'package:auth/domain/usecases/group/members/get_group_banned_members_use_case.dart';
import 'package:auth/domain/usecases/group/members/get_group_members_use_case.dart';
import 'package:auth/domain/usecases/group/members/get_group_moderators_use_case.dart';
import 'package:auth/domain/usecases/group/members/kick_member_use_case.dart';
import 'package:auth/domain/usecases/group/members/unban_member_use_case.dart';
import 'package:auth/domain/usecases/follow/accept_follow_requests.dart';
import 'package:auth/domain/usecases/follow/decline_follow_requests.dart';
import 'package:auth/domain/usecases/follow/follow_user.dart';
import 'package:auth/domain/usecases/follow/get_my_follow_requests.dart';
import 'package:auth/domain/usecases/follow/get_my_followers.dart';
import 'package:auth/domain/usecases/follow/get_my_following.dart';
import 'package:auth/domain/usecases/follow/get_user_followers.dart';
import 'package:auth/domain/usecases/follow/get_user_following.dart';
import 'package:auth/domain/usecases/follow/unfollow_user.dart';
import 'package:auth/domain/usecases/post/comment_on_post_usecase.dart';
import 'package:auth/domain/usecases/post/create_post_usecase.dart';
import 'package:auth/domain/usecases/post/delete_post_usecase.dart';
import 'package:auth/domain/usecases/post/edit_post_usecase.dart';
import 'package:auth/domain/usecases/post/get_posts_usecase.dart';
import 'package:auth/domain/usecases/post/get_post_usecase.dart';
import 'package:auth/domain/usecases/post/react_to_post_usecase.dart';
import 'package:auth/domain/usecases/post/remove_reaction_from_post_usecase.dart';
import 'package:auth/domain/usecases/post/report_post_usecase.dart';
import 'package:auth/domain/usecases/post/search_post_usecase.dart';
import 'package:auth/domain/usecases/post/share_post_usecase.dart';
import 'package:auth/domain/usecases/post/follow_user.dart';
import 'package:auth/domain/usecases/post/save_post_usecase.dart';
import 'package:auth/domain/usecases/register/register_usecase.dart';
import 'package:auth/domain/usecases/register/resend_verification_code.dart';
import 'package:auth/domain/usecases/register/verify_code.dart';
import 'package:auth/domain/usecases/sign_in/google_sign_in_and_rigester_usecases.dart';
import 'package:auth/domain/usecases/sign_in/request_otp.dart';

import 'package:auth/domain/usecases/sign_in/signin_usecase.dart';
import 'package:auth/domain/usecases/sign_in/verify_otp.dart';
import 'package:auth/domain/usecases/stats/stats_usecase.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/ban_member/ban_member_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/create_group/create_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/delete_group/delete_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_banned_members/get_banned_members_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/accept_request/accept_request_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/cancel_request/cancel_request_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/change_member_role/change_member_role_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/decline_request/decline_request_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_group/get_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_group_feed/get_groups_posts_feed_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_group_posts/group_posts_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_groups/get_groups_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_join_requests/get_join_requests_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_joined_groups/get_joined_groups_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_my_groups/get_my_groups_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/join_group/join_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/kick_member/kick_member_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/leave_group/leave_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_members_by_roles/members_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/unban_member/unban_member_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/update_group/update_group_cubit.dart';
import 'package:auth/presentation/manager/locale_cubit/locale_cubit.dart';
import 'package:auth/domain/usecases/user_profile/get_my_profile.dart';
import 'package:auth/presentation/manager/follow_cubit/follow_cubit.dart';
import 'package:auth/presentation/manager/follow_cubit/follow_request_cubit.dart';
import 'package:auth/presentation/manager/follow_cubit/get_follow_info_cubit.dart';
import 'package:auth/presentation/manager/post_cubit/create_post_cubit.dart';
import 'package:auth/presentation/manager/post_cubit/get_post/get_post_cubit.dart';
import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
import 'package:auth/presentation/manager/post_cubit/post_interaction_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/request_otp/request_otp_cubit.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/sign_in_cubit.dart';
import 'package:auth/presentation/manager/stats_cubit/stats_cubit.dart';
import 'package:auth/presentation/manager/theme_cubit/theme_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // 1. External & Core
  await dotenv.load(fileName: ".env");
  final prefs = await SharedPreferences.getInstance();
  await Hive.initFlutter();
  final statslocal = StatsLocalDatasource();
  await statslocal.init();

  String baseUrl = kIsWeb
      ? dotenv.env['LOCAL_URL']!
      : (Platform.isAndroid || Platform.isIOS
            ? dotenv.env['MOBILE_URL']!
            : dotenv.env['LOCAL_URL']!);

  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => prefs);
  sl.registerLazySingleton(() => ApiService(baseUrl: baseUrl));
  sl.registerLazySingleton(() => ErrorHandler());
  sl.registerFactory(() => LocaleCubit());

  // ==========================================================================
  // FEATURE: AUTHENTICATION
  // ==========================================================================
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(api: sl(), prefs: sl(), errorHandler: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => GoogleSignInAndRegisterUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => VerifyCode(sl()));
  sl.registerLazySingleton(() => ResendVerificationCode(sl()));
  sl.registerLazySingleton(() => SendPasswordResetOtp(sl()));
  sl.registerLazySingleton(() => VerifyOTP(sl()));

  // Cubits
  sl.registerFactory(
    () => SignInCubit(signInUseCase: sl(), googleSignInUseCase: sl()),
  );
  sl.registerFactory(() => RegisterCubit(registerUseCase: sl()));
  sl.registerFactory(() => RequestOTPCubit(sendPasswordResetOtp: sl()));

  // ==========================================================================
  // FEATURE: STATS (Football Data)
  // ==========================================================================
  sl.registerLazySingleton<StatsLocalDatasource>(() => StatsLocalDatasource());
  sl.registerLazySingleton<StatsRemoteDatasource>(
    () => StatsRemoteDatasourceImpl(sl(), sl()),
  );
  sl.registerLazySingleton<StatsRepository>(
    () => StatsRepoImpl(remoteDatasource: sl(), localDatasource: sl()),
  );
  sl.registerLazySingleton(() => StatsUseCase(sl()));
  sl.registerFactory(() => StatsCubit(sl()));

  // ==========================================================================
  // FEATURE: POSTS
  // ==========================================================================
  sl.registerLazySingleton<PostsRemoteDataSource>(
    () => PostsRemoteDataSourceImpl(api: sl(), prefs: sl(), errorHandler: sl()),
  );
  sl.registerLazySingleton<PostRepo>(
    () => PostRepositoryImpl(remoteDataSource: sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => CreatePostUseCase(sl()));
  sl.registerLazySingleton(() => DeletePostUseCase(sl()));
  sl.registerLazySingleton(() => EditPostUseCase(sl()));
  sl.registerLazySingleton(() => GetPostsUseCase(sl()));
  sl.registerLazySingleton(() => GetPostUseCase(sl()));
  sl.registerLazySingleton(() => ReactToPostUseCase(sl()));
  sl.registerLazySingleton(() => RemoveReactionFromPostUseCase(sl()));
  sl.registerLazySingleton(() => ReportPostUseCase(sl()));
  sl.registerLazySingleton(() => SearchPostsUseCase(sl()));
  sl.registerLazySingleton(() => SharePostUseCase(sl()));
  sl.registerLazySingleton(() => FollowUserUseCase(sl()));
  sl.registerLazySingleton(() => SavePostUseCase(sl()));
sl.registerLazySingleton(() => CommentOnPostUseCase(sl()));
  sl.registerFactory(
    () => PostCubit(getPostsUseCase: sl(), deletePostUseCase: sl(),editPostUseCase: sl()),
  );

  sl.registerFactory(
    () => PostInteractionCubit(
      reactToPostUseCase: sl(),
      sharePostUseCase: sl(),
      commentOnPostUseCase: sl(),
      followUserUseCase: sl(),
      toggleSavePostUseCase: sl(),
      reportPostUseCase: sl(),
      removeReactionFromPostUseCase: sl(),
    ),
  );

  // ==========================================================================
  // FEATURE: COMMENTS
  // ==========================================================================
  sl.registerLazySingleton<CommentsRemoteDataSource>(
    () => CommentsRemoteDataSourceImpl(
      api: sl(),
      prefs: sl(),
      errorHandler: sl(),
    ),
  );
  sl.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(remoteDataSource: sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => AddCommentUseCase(sl()));
  sl.registerLazySingleton(() => DeleteCommentUseCase(sl()));
  sl.registerLazySingleton(() => EditCommentUseCase(sl()));
  sl.registerLazySingleton(() => GetCommentsUseCase(sl()));
  sl.registerLazySingleton(() => GetRepliesUseCase(sl()));
  sl.registerLazySingleton(() => MentionUsersInCommentUseCase(sl()));
  sl.registerLazySingleton(() => ReactToCommentUseCase(sl()));

  // Cubit
  sl.registerFactory(
    () => CommentCubit(
      addCommentUseCase: sl(),
      deleteCommentUseCase: sl(),
      editCommentUseCase: sl(),
      getCommentsUseCase: sl(),
      getRepliesUseCase: sl(),
      mentionUsersInCommentUseCase: sl(),
      reactToCommentUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () =>
        CreatePostCubit(createPostUseCase: sl(), createGroupPostUseCase: sl()),
  );
  sl.registerFactory(() => GetPostCubit(getPostUseCase: sl()));


  // groups
  sl.registerLazySingleton<GroupRemoteDataSource>(
    () => GroupRemoteDataSourceImpl(api: sl(), prefs: sl(), errorHandler: sl()),
  );
  sl.registerLazySingleton<GroupRepo>(
    () => GroupRepoImpl(remoteDataSource: sl()),
  );

  // create group
  sl.registerLazySingleton(() => CreateGroupUseCase(sl()));
  sl.registerFactory(() => CreateGroupCubit(createGroupUseCase: sl()));

  // get group
  sl.registerLazySingleton(() => GetGroupUseCase(sl()));
  sl.registerFactory(() => GetGroupCubit(getGroupUseCase: sl()));

  //get groups
  sl.registerLazySingleton(() => GetAllGroupsUseCase(sl()));
  sl.registerFactory(() => GetAllGroupsCubit(getAllGroupsUseCase: sl()));

  // update group
  sl.registerLazySingleton(() => UpdateGroupUseCase(sl()));
  sl.registerFactory(() => UpdateGroupCubit(updateGroupUseCase: sl()));

  // delete group
  sl.registerLazySingleton(() => DeleteGroupUseCase(sl()));
  sl.registerFactory(() => DeleteGroupCubit(deleteGroupUseCase: sl()));

  // join
  sl.registerLazySingleton(() => JoinGroupUseCase(sl()));
  sl.registerFactory(() => JoinGroupCubit(joinGroupUseCase: sl()));
  //leave
  sl.registerLazySingleton(() => LeaveGroupUseCase(sl()));
  sl.registerFactory(() => LeaveGroupCubit(leaveGroupUseCase: sl()));
  //cancel request
  sl.registerLazySingleton(() => CancelRequestUseCase(sl()));
  sl.registerFactory(() => CancelRequestGroupCubit(cancelRequestUseCase: sl()));
  //accept request
  sl.registerLazySingleton(() => AcceptJoinRequestUseCase(sl()));
  sl.registerFactory(() => AcceptRequestCubit(acceptJoinRequestUseCase: sl()));
  // declie request
  sl.registerLazySingleton(() => DeclineJoinRequestUseCase(sl()));
  sl.registerFactory(
    () => DeclineRequestCubit(declineJoinRequestUseCase: sl()),
  );
  // get requests
  sl.registerLazySingleton(() => GetJoinRequestsUseCase(sl()));
  sl.registerFactory(() => GetJoinRequestsCubit(getJoinRequestsUseCase: sl()));
  // change member role
  sl.registerLazySingleton(() => ChangeMemberRoleUseCase(sl()));
  sl.registerFactory(
    () => ChangeMemberRoleCubit(changeMemberRoleUseCase: sl()),
  );
  // get members
  sl.registerLazySingleton(() => GetGroupMembersUseCase(sl()));
  // get admins
  sl.registerLazySingleton(() => GetGroupAdminsUseCase(sl()));
  // get moderators
  sl.registerLazySingleton(() => GetGroupModeratorsUseCase(sl()));
  // get banned members
  sl.registerLazySingleton(() => GetGroupBannedMembersUseCase(sl()));
  sl.registerFactory(
    () => GetBannedMembersCubit(getGroupBannedMembersUseCase: sl()),
  );
  // kick member
  sl.registerLazySingleton(() => KickMemberUseCase(sl()));
  sl.registerFactory(() => KickMemberCubit(kickMemberUseCase: sl()));
  // ban member
  sl.registerLazySingleton(() => BanMemberUseCase(sl()));
  sl.registerFactory(() => BanMemberCubit(banMemberUseCase: sl()));
  // unban member
  sl.registerLazySingleton(() => UnbanMemberUseCase(sl()));
  sl.registerFactory(() => UnbanMemberCubit(unbanMemberUseCase: sl()));
  // group members
  sl.registerFactory(() => GroupMembersCubit(sl(), sl(), sl()));

  // get my groups
  sl.registerLazySingleton(() => GetMyGroupsUseCase(sl()));
  sl.registerFactory(() => GetMyGroupsCubit(getMyGroupsUseCase: sl()));

  // get joined groups
  sl.registerLazySingleton(() => GetJoinedGroupsUseCase(sl()));
  sl.registerFactory(() => GetJoinedGroupsCubit(getJoinedGroupsUseCase: sl()));

  // create group post
  sl.registerLazySingleton(() => CreateGroupPostUseCase(sl()));

  // get group posts
  sl.registerFactory(() => GroupPostsCubit(getGroupPostsUseCase: sl(),deleteGroupPostUseCase: sl(),));
  sl.registerLazySingleton(() => GetGroupPostsUseCase(sl()));
  sl.registerLazySingleton(() => DeleteGroupPostUseCase(sl()));

  // get groups posts feed
    sl.registerFactory(() => GetGroupsPostsFeedCubit(getGroupsPostsFeedUseCase: sl()));
  sl.registerLazySingleton(() => GetGroupsPostsFeedUseCase(sl()));
  // ==========================================================================
  // CORE / GLOBAL
  // ==========================================================================
  sl.registerFactory(() => ThemeCubit(prefs));

  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(api: sl(), errorHandler: sl()),
  );
  sl.registerLazySingleton<UserProfileRepo>(
    () => UserProfileRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerFactory(() => ProfileCubit(getMyProfile: sl()));
  sl.registerLazySingleton(() => GetMyProfile(sl()));

  //follow
  sl.registerLazySingleton<FollowRemoteDataSource>(
    () => FollowRemoteDataSourceImpl(api: sl(), errorHandler: sl()),
  );
  sl.registerLazySingleton<FollowRepo>(
    () => FollowRepoImpl(remote: sl()),
  );

  sl.registerLazySingleton(() => FollowUser(sl()));
  sl.registerLazySingleton(() => UnfollowUser(sl()));
  sl.registerLazySingleton(() => GetMyFollowRequests(sl()));
  sl.registerLazySingleton(() => AcceptFollowRequest(sl()));
  sl.registerLazySingleton(() => DeclineFollowRequest(sl()));
  sl.registerLazySingleton(() => GetUserFollowers(sl()));
  sl.registerLazySingleton(() => GetUserFollowing(sl()));
  sl.registerLazySingleton(() => GetMyFollowers(sl()));
  sl.registerLazySingleton(() => GetMyFollowing(sl()));
  sl.registerFactory(
    () => FollowCubit(followUserUseCase: sl(), unfollowUserUseCase: sl()),
  );
  sl.registerFactory(
    () => FollowRequestCubit(
      getMyFollowRequestsUseCase: sl(),
      acceptFollowRequestUseCase: sl(),
      declineFollowRequestUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => FollowInfoCubit(
      getUserFollowersUseCase: sl(),
      getUserFollowingUseCase: sl(),
      getMyFollowersUseCase: sl(),
      getMyFollowingUseCase: sl(),
    ),
  );
}
