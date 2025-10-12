import 'package:auth/core/app_routes.dart';
import 'package:auth/domain/usecases/sign_in/request_otp.dart';
import 'package:auth/presentation/authentication/register/register_view.dart';
import 'package:auth/presentation/authentication/register/verify_code_view.dart';
import 'package:auth/presentation/authentication/signIn/request_email_view.dart';
import 'package:auth/presentation/authentication/signIn/forget_password_otp_view.dart';
import 'package:auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:auth/presentation/manager/register_cubit/verify_code_cubit.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/forget_password_otp_cubit.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/request_otp/request_otp_cubit.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/sign_in_cubit.dart';
import 'package:auth/presentation/authentication/signIn/sign_in_view.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(
    DevicePreview(enabled: !kReleaseMode, builder: (context) => const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: AppRoutes.signIn,
      routes: [
        /// 🟦 Sign In
        GoRoute(
          path: AppRoutes.signIn,
          builder: (context, state) => BlocProvider(
            create: (_) => di.sl<SignInCubit>(),
            child: const SignInPage(),
          ),
        ),

        /// 🟩 Register
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => BlocProvider(
            create: (_) => di.sl<RegisterCubit>(),
            child: const RegisterPage(),
          ),
        ),

        /// 🟨 Verify Code
        GoRoute(
          path: AppRoutes.verifyCode,
          builder: (context, state) {
            final args = state.extra as Map<String, String?>;
            final email = args['email']!;
            final username = args['username']!;
            return BlocProvider(
              create: (_) => VerifyCodeCubit(
                verifyCode: di.sl(),
                resendVerificationCode: di.sl(),
                email: email,
                username: username,
              ),
              child: VerifyCodePage(email: email),
            );
          },
        ),

        /// 🟧 Request Reset Password
        GoRoute(
          path: AppRoutes.requsetResetPassword,
          builder: (context, state) {
            final username = '';
            return BlocProvider(
              create: (_) => RequestOTPCubit(
                sendPasswordResetOtp: di.sl<SendPasswordResetOtp>(),
              ),
              child: RequestEmailView(
                isForVerification: false,
                username: username,
              ),
            );
          },
        ),

        /// 🟦 Change Email for verfication code
        GoRoute(
          path: AppRoutes.changeEmailVerification,
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>;
            final username = data['username'] as String;
            final cubit = data['cubit'] as VerifyCodeCubit;

            return BlocProvider.value(
              value: cubit,
              child: RequestEmailView(
                isForVerification: true,
                username: username,
              ),
            );
          },
        ),

        /// 🟦 Change Email for OTP
        GoRoute(
          path: AppRoutes.changeEmailOTP,
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>;
            final cubit = data['cubit'] as RequestOTPCubit;

            return BlocProvider.value(
              value: cubit,
              child: RequestEmailView(isForVerification: false, username: ''),
            );
          },
        ),

        /// 🟦 Forget Password OTP
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

        /// 🟢 Home Page
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const HomePage(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Auth App',
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Welcome! Email Verified Successfully')),
    );
  }
}
