import 'package:auth/core/custom_bottom_navigation_bar.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/usecases/sign_in/verify_otp.dart';
import 'package:auth/presentation/authentication/signIn/forget_password_otp_view.dart';
import 'package:auth/presentation/chats/chat_info_button/chat_info_view.dart';
import 'package:auth/presentation/chats/chat_screen/chat_view.dart';
import 'package:auth/presentation/chats/messages_screen/messages_view.dart';
import 'package:auth/presentation/groups/create_group/add_cover_photo_view.dart';
import 'package:auth/presentation/groups/create_group/create_group_view.dart';
import 'package:auth/presentation/groups/group_feed/group_feed_view.dart';
import 'package:auth/presentation/groups/groups_search_view.dart';
import 'package:auth/presentation/groups/groups_view.dart';
import 'package:auth/presentation/groups/group_preview/group_preview_view.dart';
import 'package:auth/presentation/groups/manage_group/banned_members_list.dart';
import 'package:auth/presentation/groups/manage_group/manage_group_view.dart';
import 'package:auth/presentation/groups/manage_group/members_requests_list_view.dart';
import 'package:auth/presentation/groups/manage_group/pending_posts_view.dart';
import 'package:auth/presentation/groups/manage_group/people_view/people_view.dart';
import 'package:auth/presentation/groups/manage_group/reported_posts_view.dart';
import 'package:auth/presentation/groups/my_group/my_group_view.dart';
import 'package:auth/presentation/groups/widgets/edit_post_page.dart';
import 'package:auth/presentation/interests/favourite_players_view.dart';
import 'package:auth/presentation/interests/favourite_teams_view.dart';
import 'package:auth/presentation/manager/group_cubit/ban_member/ban_member_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/create_group/create_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/delete_group/delete_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_banned_members/get_banned_members_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/accept_request/accept_request_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/cancel_request/cancel_request_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/change_member_role/change_member_role_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/decline_request/decline_request_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_group/get_group_cubit.dart';
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
import 'package:auth/presentation/manager/profile_cubit/interests/select_interests_cubit.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/forget_password_otp_cubit.dart';
import 'package:auth/presentation/home/widgets/edit_page.dart';
import 'package:auth/presentation/manager/follow_cubit/follow_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/change_password_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_liked_posts_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_social_info_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_update_cubit.dart';
import 'package:auth/presentation/reels/reels_page.dart';
import 'package:auth/presentation/settings/settings_view.dart';
import 'package:auth/presentation/settings/theme_view.dart';
import 'package:auth/presentation/user/change_password_screen.dart';
import 'package:auth/presentation/user/edit_profile_view.dart';
import 'package:auth/presentation/user/liked_posts_view.dart';
import 'package:auth/presentation/user/social_info_view.dart';
import 'package:auth/presentation/user/user_profile_settings_view.dart';
import 'package:auth/presentation/stats/stats_view.dart';
import 'package:auth/presentation/user/user_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/presentation/home/home_page.dart';
import 'package:auth/presentation/authentication/signIn/sign_in_view.dart';
import 'package:auth/presentation/authentication/register/register_view.dart';
import 'package:auth/presentation/authentication/register/verify_code_view.dart';
import 'package:auth/presentation/authentication/signIn/request_email_view.dart';
import 'package:auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:auth/presentation/manager/register_cubit/verify_code_cubit.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/request_otp/request_otp_cubit.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/sign_in_cubit.dart';
import 'package:auth/domain/usecases/sign_in/request_otp.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/auth_shell.dart';
import 'package:auth/injection_container.dart' as di;

int previousTabIndex = 0;
final GlobalKey<NavigatorState> _interestsShellKey = GlobalKey<NavigatorState>(
  debugLabel: 'interests_shell',
);

CustomTransitionPage buildAnimatedPage({
  required Widget child,
  required int newIndex,
}) {
  final bool leftToRight = newIndex > previousTabIndex ? true : false;
  previousTabIndex = newIndex;

  return CustomTransitionPage(
    key: ValueKey(child.runtimeType.toString() + newIndex.toString()),
    child: child,
    opaque: true,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final begin = Offset(leftToRight ? 1.0 : -1.0, 0.0);
      const end = Offset.zero;
      final curve = Curves.easeInOut;
      final tween = Tween(
        begin: begin,
        end: end,
      ).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

GoRouter createRouter(bool isLoggedIn) {
  return GoRouter(
    // initialLocation: AppRoutes.selectTeams,
    initialLocation: isLoggedIn ? AppRoutes.home : AppRoutes.signIn,
    routes: [
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => BlocProvider(
          create: (_) => di.sl<SignInCubit>(),
          child: const SignInPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => BlocProvider(
          create: (_) => di.sl<RegisterCubit>(),
          child: const RegisterPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.verifyCode,
        builder: (context, state) {
          final args = state.extra as Map<String, String?>;
          return BlocProvider(
            create: (_) => VerifyCodeCubit(
              verifyCode: di.sl(),
              resendVerificationCode: di.sl(),
              email: args['email']!,
              username: args['username']!,
            ),
            child: VerifyCodePage(email: args['email']!),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.requsetResetPassword,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => RequestOTPCubit(
              sendPasswordResetOtp: di.sl<SendPasswordResetOtp>(),
            ),
            child: RequestEmailView(isForVerification: false, username: ''),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.forgetPasswordOtp,
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    ForgetPasswordOTPCubit(verifyOTP: di.sl<VerifyOTP>()),
              ),
              BlocProvider(create: (context) => di.sl<RequestOTPCubit>()),
            ],
            child: ForgetPasswordOtp(email: email),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.editPostCaption,
        name: 'edit_post',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          final post = extras['post'] as Post;
          final groupCubit = extras['groupCubit'] as GroupPostsCubit?;

          if (groupCubit != null) {
            return BlocProvider.value(
              value: groupCubit,
              child: EditPostPage(post: post),
            );
          }
          return EditPostPage(post: post);
        },
      ),
      ShellRoute(
        navigatorKey: _interestsShellKey,
        builder: (context, state, child) {
          return BlocProvider(
            create: (context) => di.sl<SelectInterestsCubit>(),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.selectTeams,
            builder: (context, state) {
              final bool isEdit = state.extra as bool? ?? false;
              return FavouriteTeamsView(isEditTeams: isEdit);
            },
            routes: [
              GoRoute(
                path: 'select-players',
                builder: (context, state) {
                  final bool isEdit = state.extra as bool? ?? false;
                  return FavouritePlayersView(isEditPlayers: isEdit);
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/app',
        builder: (context, state) => const SizedBox.shrink(),
        routes: [
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return AuthShell(navigationShell: navigationShell);
            },
            branches: [
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: 'home',
                    pageBuilder: (context, state) =>
                        NoTransitionPage(child: const HomePage()),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (context, state) {
                          final args =
                              state.extra as Map<String, dynamic>? ?? {};
                          return EditPage(
                            initialText: args['initialText'],
                            title: args['title'],
                            onSave: args['onSave'],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: 'reels',
                    pageBuilder: (context, state) =>
                        NoTransitionPage(child: const ReelsPage()),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: 'chatbot',
                    pageBuilder: (context, state) =>
                        NoTransitionPage(child: const ChatBotPage()),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: 'stats',
                    pageBuilder: (context, state) =>
                        NoTransitionPage(child: const StatsScreenView()),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: 'profile',
                    pageBuilder: (context, state) => NoTransitionPage(
                      child: BlocProvider<FollowCubit>(
                        create: (context) => di.sl<FollowCubit>(),
                        child: UserProfileView(),
                      ),
                    ),
                    routes: [
                      GoRoute(
                        path: 'follow_info',
                        builder: (context, state) {
                          final String? tabString =
                              state.uri.queryParameters['tab'];
                          final int index = int.tryParse(tabString ?? '0') ?? 0;
                          return BlocProvider(
                            create: (context) => di.sl<ProfileSocialInfoCubit>()
                              ..fetchFollowers(userId: null)
                              ..fetchFollowing(userId: null)
                              ..fetchRequests()
                              ..fetchSuggestions(),
                            child: SocialInfoScreen(initialTabIndex: index),
                          );
                        },
                      ),
                      GoRoute(
                        path: 'settings',
                        builder: (context, state) => BlocProvider<FollowCubit>(
                          create: (context) => di.sl<FollowCubit>(),
                          child: const UserProfileSettings(),
                        ),
                        routes: [
                          GoRoute(
                            path: 'edit',
                            builder: (context, state) {
                              final profileState = context
                                  .read<ProfileCubit>()
                                  .state;
                              String currentName = "";
                              String currentBio = "";
                              String currentAvatar = "";
                              if (profileState is ProfileLoaded) {
                                currentName = profileState.user.name;
                                currentBio = profileState.user.bio ?? "";
                                currentAvatar = profileState.user.avatar;
                              }
                              return BlocProvider(
                                create: (context) => ProfileUpdateCubit(
                                  updateProfileUseCase: di.sl(),
                                  changePasswordUseCase: di.sl(),
                                  initialName: currentName,
                                  initialBio: currentBio,
                                  initialAvatar: currentAvatar,
                                ),
                                child: const EditProfileScreen(),
                              );
                            },
                          ),
                          GoRoute(
                            path: 'liked_posts',
                            builder: (context, state) => BlocProvider(
                              create: (context) => di.sl<LikedPostsCubit>(),
                              child: const LikedPostsScreen(),
                            ),
                          ),
                          GoRoute(
                            path: 'change_password',
                            builder: (context, state) => BlocProvider(
                              create: (context) => di.sl<ChangePasswordCubit>(),
                              child: ChangePasswordScreen(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: 'messages',
            builder: (context, state) => const MessagesView(),
            routes: [
              GoRoute(
                path: 'chat',
                builder: (context, state) => const ChatView(),
                routes: [
                  GoRoute(
                    path: 'chat_info',
                    builder: (context, state) => const ChatInfoView(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsView(),
        routes: [
          GoRoute(
            path: 'theme',
            builder: (context, state) => const ThemeView(),
          ),
          ShellRoute(
            builder: (context, state, child) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => di.sl<GetAllGroupsCubit>()..loadData(),
                  ),
                  BlocProvider(
                    create: (context) => di.sl<GetMyGroupsCubit>()..loadData(),
                  ),
                  BlocProvider(
                    create: (context) =>
                        di.sl<GetJoinedGroupsCubit>()..loadData(),
                  ),
                ],
                child: child,
              );
            },
            routes: [
              GoRoute(
                path: 'groups',
                builder: (context, state) {
                  return BlocProvider(
                    create: (context) =>
                        di.sl<GroupPostsCubit>()..getFeedPosts(refresh: true),
                    child: const GroupsView(),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'search-groups',
                    name: 'search-groups',
                    builder: (context, state) => const GroupsSearchView(),
                  ),
                  GoRoute(
                    path: 'group_preview/:groupId',
                    builder: (context, state) {
                      final String groupId = state.pathParameters['groupId']!;
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => di.sl<JoinGroupCubit>(),
                          ),
                          BlocProvider(
                            create: (context) =>
                                di.sl<CancelRequestGroupCubit>(),
                          ),
                          BlocProvider(
                            create: (context) =>
                                di.sl<GetGroupCubit>()..getGroup(groupId),
                          ),
                        ],
                        child: const GroupPreviewView(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'group_feed/:groupId',
                    builder: (context, state) {
                      final String groupId = state.pathParameters['groupId']!;
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) =>
                                di.sl<GetGroupCubit>()..getGroup(groupId),
                          ),
                          BlocProvider(
                            create: (context) => di.sl<LeaveGroupCubit>(),
                          ),
                        ],
                        child: GroupFeedView(groupId: groupId),
                      );
                    },
                  ),
                  ShellRoute(
                    builder: (context, state, child) {
                      return BlocProvider(
                        create: (context) => di.sl<CreateGroupCubit>(),
                        child: child,
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'create_group',
                        builder: (context, state) => const CreateGroupView(),
                        routes: [
                          GoRoute(
                            path: 'add_cover_photo',
                            builder: (context, state) =>
                                const AddCoverPhotoView(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'my_group/:groupId',
                    builder: (context, state) {
                      final String groupId = state.pathParameters['groupId']!;
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) =>
                                di.sl<GetGroupCubit>()..getGroup(groupId),
                          ),
                          BlocProvider(
                            create: (context) => di.sl<UpdateGroupCubit>(),
                          ),
                          BlocProvider(
                            create: (context) =>
                                di.sl<GroupPostsCubit>()
                                  ..getPosts(groupId: groupId),
                          ),
                        ],
                        child: MyGroupView(
                          key: ValueKey('my_group_$groupId'),
                          groupId: groupId,
                        ),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'manage_group',
                        name: 'manage_group',
                        builder: (context, state) {
                          final String groupId =
                              state.pathParameters['groupId']!;
                          return BlocProvider(
                            create: (context) => di.sl<DeleteGroupCubit>(),
                            child: ManageGroupView(groupId: groupId),
                          );
                        },
                        routes: [
                          GoRoute(
                            path: 'members_requests',
                            name: 'members_requests',
                            builder: (context, state) {
                              final String groupId =
                                  state.pathParameters['groupId']!;
                              return MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (context) =>
                                        di.sl<GetJoinRequestsCubit>()
                                          ..groupId = groupId
                                          ..loadData(),
                                  ),
                                  BlocProvider(
                                    create: (context) =>
                                        di.sl<AcceptRequestCubit>(),
                                  ),
                                  BlocProvider(
                                    create: (context) =>
                                        di.sl<DeclineRequestCubit>(),
                                  ),
                                ],
                                child: MembersRequestsListView(
                                  groupId: groupId,
                                ),
                              );
                            },
                          ),
                          GoRoute(
                            path: 'pending_posts',
                            name: 'pending_posts',
                            builder: (context, state) =>
                                const PendingPostsView(),
                          ),
                          GoRoute(
                            path: 'reported_posts',
                            name: 'reported_posts',
                            builder: (context, state) =>
                                const ReportedPostsView(),
                          ),
                          GoRoute(
                            path: 'members',
                            name: 'members',
                            builder: (context, state) {
                              final String groupId =
                                  state.pathParameters['groupId']!;
                              return MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (context) =>
                                        di.sl<GroupMembersCubit>()
                                          ..getAllGroupData(groupId),
                                  ),
                                  BlocProvider(
                                    create: (context) =>
                                        di.sl<ChangeMemberRoleCubit>(),
                                  ),
                                  BlocProvider(
                                    create: (context) =>
                                        di.sl<BanMemberCubit>(),
                                  ),
                                  BlocProvider(
                                    create: (context) =>
                                        di.sl<KickMemberCubit>(),
                                  ),
                                ],
                                child: PeopleView(groupId: groupId),
                              );
                            },
                          ),
                          GoRoute(
                            path: 'banned_members',
                            name: 'banned_members',
                            builder: (context, state) {
                              final String groupId =
                                  state.pathParameters['groupId']!;
                              return MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (context) =>
                                        di.sl<GetBannedMembersCubit>()
                                          ..groupId = groupId
                                          ..loadData(),
                                  ),
                                  BlocProvider(
                                    create: (context) =>
                                        di.sl<UnbanMemberCubit>(),
                                  ),
                                ],
                                child: BannedMembersList(groupId: groupId),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
