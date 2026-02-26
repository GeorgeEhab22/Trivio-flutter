import 'package:auth/core/custom_bottom_navigation_bar.dart';
import 'package:auth/presentation/chats/chat_info_button/chat_info_view.dart';
import 'package:auth/presentation/chats/chat_screen/chat_view.dart';
import 'package:auth/presentation/chats/messages_screen/messages_view.dart';
import 'package:auth/presentation/manager/follow_cubit/follow_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/change_password_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_liked_posts_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_social_info_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_update_cubit.dart';
import 'package:auth/presentation/reels/reels_page.dart';
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
    initialLocation: isLoggedIn ? '/app/profile' : '/signin',
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
                        builder: (context, state) => BlocProvider(
                          create: (context) {
                            final cubit = di.sl<ProfileSocialInfoCubit>();
                            cubit.fetchFollowers(userId: null);
                            cubit.fetchFollowing(userId: null);
                            cubit.fetchRequests();

                            return cubit;
                          },
                          child: const SocialInfoScreen(),
                        ),
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
                            pageBuilder: (context, state) => NoTransitionPage(
                              child: BlocProvider(
                                create: (context) =>
                                    di.sl<ProfileUpdateCubit>(),
                                child: EditProfileScreen(),
                              ),
                            ),
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
