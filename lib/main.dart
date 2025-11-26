import 'dart:io';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/auth_shell.dart';
import 'package:auth/core/custom_bottom_navigation_bar.dart';
import 'package:auth/presentation/home/home_page.dart';
import 'package:auth/presentation/authentication/signIn/sign_in_view.dart';
import 'package:auth/presentation/authentication/register/register_view.dart';
import 'package:auth/presentation/authentication/register/verify_code_view.dart';
import 'package:auth/presentation/authentication/signIn/request_email_view.dart';
import 'package:auth/presentation/authentication/signIn/forget_password_otp_view.dart';
import 'package:auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:auth/presentation/manager/register_cubit/verify_code_cubit.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/forget_password_otp_cubit.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/request_otp/request_otp_cubit.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/sign_in_cubit.dart';
import 'package:auth/domain/usecases/sign_in/request_otp.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await dotenv.load(fileName: ".env");

  final bool isDesktop =
      !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
  final bool enableDevicePreview = !kReleaseMode && (isDesktop || kIsWeb);
  runApp(
    DevicePreview(
      enabled: enableDevicePreview,
      builder: (context) => const MyApp(),
    ),
  );
}

// global to track previous tab for direction-aware animation
int previousTabIndex = 0;

/// Helper: build a CustomTransitionPage that slides left/right based on index direction
CustomTransitionPage buildAnimatedPage({
  required Widget child,
  required int newIndex,
}) {
  // Determine direction: if newIndex > previousTabIndex we slide left (from right to left)
  final bool leftToRight = newIndex > previousTabIndex ? true : false;
  // store for next navigation
  previousTabIndex = newIndex;

  return CustomTransitionPage(
    key: ValueKey(child.runtimeType.toString() + newIndex.toString()),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final begin = Offset(leftToRight ? 1.0 : -1.0, 0.0); // enter from right if forward
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/app/home', // must point to nested /app route
      routes: [
        // Public routes
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
          path: AppRoutes.changeEmailVerification,
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>;
            return BlocProvider.value(
              value: data['cubit'] as VerifyCodeCubit,
              child: RequestEmailView(
                isForVerification: true,
                username: data['username'],
              ),
            );
          },
        ),

        GoRoute(
          path: AppRoutes.changeEmailOTP,
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>;
            return BlocProvider.value(
              value: data['cubit'] as RequestOTPCubit,
              child: RequestEmailView(isForVerification: false, username: ''),
            );
          },
        ),

        GoRoute(
          path: AppRoutes.forgetPasswordOtp,
          builder: (context, state) {
            final email = state.extra as String;
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => ForgetPasswordOTPCubit(verifyOTP: di.sl()),
                ),
                BlocProvider(
                  create: (_) => RequestOTPCubit(
                    sendPasswordResetOtp: di.sl<SendPasswordResetOtp>(),
                  ),
                ),
              ],
              child: ForgetPasswordOtp(email: email),
            );
          },
        ),

        // Parent /app route that contains the ShellRoute
        GoRoute(
          path: '/app', // '/app'
          builder: (context, state) => const SizedBox.shrink(),
          routes: [
            ShellRoute(
              builder: (context, state, child) => AuthShell(child: child),
              routes: [
                // Use pageBuilder with our animated page helper
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
          ],
        ),
      ],
    );

    return MaterialApp.router(
      title: 'TRIVIO',
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(16),
        ),
      ),
      routerConfig: router,
    );
  }
}
