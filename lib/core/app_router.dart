import 'package:auth/core/custom_bottom_navigation_bar.dart';
import 'package:auth/presentation/chats/chat_screen/chat_view.dart';
import 'package:auth/presentation/chats/messages_screen/messages_view.dart';
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
      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/app/home',
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
          ShellRoute(
            builder: (context, state, child) => AuthShell(child: child),
            routes: [
              GoRoute(
                path: 'home',
                pageBuilder: (context, state) =>
                    buildAnimatedPage(child: const HomePage(), newIndex: 0),
              ),
              GoRoute(
                path: 'reels',
                pageBuilder: (context, state) =>
                    buildAnimatedPage(child: const ReelsPage(), newIndex: 1),
              ),
              GoRoute(
                path: 'chatbot',
                pageBuilder: (context, state) =>
                    buildAnimatedPage(child: const ChatBotPage(), newIndex: 2),
              ),
              GoRoute(
                path: 'groups',
                pageBuilder: (context, state) =>
                    buildAnimatedPage(child: const GroupPage(), newIndex: 3),
              ),
              GoRoute(
                path: 'stats',
                pageBuilder: (context, state) =>
                    buildAnimatedPage(child: const StatsPage(), newIndex: 4),
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
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
