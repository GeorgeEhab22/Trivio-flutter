import 'package:auth/core/custom_bottom_navigation_bar.dart';
import 'package:auth/domain/usecases/sign_in/verify_otp.dart';
import 'package:auth/presentation/authentication/signIn/forget_password_otp_view.dart';
import 'package:auth/presentation/chats/chat_info_button/chat_info_view.dart';
import 'package:auth/presentation/chats/chat_screen/chat_view.dart';
import 'package:auth/presentation/chats/messages_screen/messages_view.dart';
import 'package:auth/presentation/groups/create_group/add_cover_photo_view.dart';
import 'package:auth/presentation/groups/create_group/create_group_view.dart';
import 'package:auth/presentation/groups/group_feed/group_feed_view.dart';
import 'package:auth/presentation/groups/groups_view.dart';
import 'package:auth/presentation/groups/group_preview/group_preview_view.dart';
import 'package:auth/presentation/groups/manage_group/banned_members_list.dart';
import 'package:auth/presentation/groups/manage_group/manage_group_view.dart';
import 'package:auth/presentation/groups/manage_group/members_requests_list_view.dart';
import 'package:auth/presentation/groups/manage_group/pending_posts_view.dart';
import 'package:auth/presentation/groups/manage_group/people_view/people_view.dart';
import 'package:auth/presentation/groups/manage_group/reported_posts_view.dart';
import 'package:auth/presentation/groups/my_group/my_group_view.dart';
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
    // initialLocation: AppRoutes.groups,
    // initialLocation: '/signin',
    initialLocation: isLoggedIn ? '/app/home' : '/signin',
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
      GoRoute(path: '/theme', builder: (context, state) => const ThemeView()),
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
                      //TODO: move this router int profile page and refactor edit page
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
                          final String? tabString = state.uri.queryParameters['tab'];
                          final int index = int.tryParse(tabString??'0')??0;
                          return BlocProvider(
                          create: (context) {
                            final cubit = di.sl<ProfileSocialInfoCubit>();
                            cubit.fetchFollowers(userId: null);
                            cubit.fetchFollowing(userId: null);
                            cubit.fetchRequests();

                            return cubit;
                          },
                          child: SocialInfoScreen(initialTabIndex: index,),
                        );
                        }
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
                              String currentAvatar ="";

                              if (profileState is ProfileLoaded) {
                                currentName = profileState.user.name;
                                currentBio = profileState.user.bio!;
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
    ],
  );
}
