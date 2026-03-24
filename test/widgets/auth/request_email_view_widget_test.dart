import 'package:auth/core/app_routes.dart';
import 'package:auth/core/errors/failure.dart';
import 'package:auth/presentation/authentication/signIn/request_email_view.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/request_otp/request_otp_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixtures/auth_test_data.dart';
import '../../helpers/golden_test_config.dart';
import '../../helpers/widget_test_harness.dart';
import '../../mocks/auth_usecase_mocks.dart';

GoRouter _buildRequestEmailRouter(RequestOTPCubit cubit) {
  return GoRouter(
    initialLocation: '/host',
    routes: <RouteBase>[
      GoRoute(
        path: '/host',
        builder: (context, state) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => context.push('/request-email'),
              child: const Text('Open request email'),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/request-email',
        builder: (context, state) => BlocProvider<RequestOTPCubit>.value(
          value: cubit,
          child: const RequestEmailView(
            username: 'u',
            isForVerification: false,
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.forgetPasswordOtp,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('forget-password-otp-screen')),
        ),
      ),
    ],
  );
}

void main() {
  group('RequestEmailView widget tests', () {
    late MockSendPasswordResetOtp sendOtpUseCase;
    late RequestOTPCubit cubit;

    setUp(() {
      sendOtpUseCase = MockSendPasswordResetOtp();
      stubRequestOtpSuccess(sendOtpUseCase);
      cubit = RequestOTPCubit(sendPasswordResetOtp: sendOtpUseCase);
    });

    tearDown(() async {
      if (!cubit.isClosed) {
        await cubit.close();
      }
    });

    group('render', () {
      testWidgets('renders forgot password content', (tester) async {
        final router = _buildRequestEmailRouter(cubit);
        addTearDown(router.dispose);

        await pumpRouterApp(tester, router: router);
        await tester.tap(find.text('Open request email'));
        await tester.pumpAndSettle();

        expect(find.text('Forgot Password?'), findsOneWidget);
        expect(
          find.text(
            "Don't worry! It happens. Please enter the email address associated with your account",
          ),
          findsOneWidget,
        );
        expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
        expect(find.widgetWithText(ElevatedButton, 'Send OTP'), findsOneWidget);
      });
    });

    group('interaction', () {
      testWidgets('shows validation error on empty submit', (tester) async {
        final router = _buildRequestEmailRouter(cubit);
        addTearDown(router.dispose);

        await pumpRouterApp(tester, router: router);
        await tester.tap(find.text('Open request email'));
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(ElevatedButton, 'Send OTP'));
        await tester.pump();

        expect(find.text('Please enter your email'), findsOneWidget);
        verifyNever(() => sendOtpUseCase(email: any(named: 'email')));
      });

      testWidgets('navigates to OTP screen on successful submit', (
        tester,
      ) async {
        final router = _buildRequestEmailRouter(cubit);
        addTearDown(router.dispose);

        await pumpRouterApp(tester, router: router);
        await tester.tap(find.text('Open request email'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'),
          kValidEmail,
        );
        await tester.tap(find.widgetWithText(ElevatedButton, 'Send OTP'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        verify(() => sendOtpUseCase(email: kValidEmail)).called(1);
        expect(find.text('forget-password-otp-screen'), findsOneWidget);
        await tester.pump(const Duration(seconds: 3));
        await cubit.close();
      });

      testWidgets('shows failure snackbar message on request error', (
        tester,
      ) async {
        stubRequestOtpFailure(
          sendOtpUseCase,
          failure: const ServerFailure('server_error'),
        );

        final router = _buildRequestEmailRouter(cubit);
        addTearDown(router.dispose);

        await pumpRouterApp(tester, router: router);
        await tester.tap(find.text('Open request email'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'),
          kValidEmail,
        );
        await tester.tap(find.widgetWithText(ElevatedButton, 'Send OTP'));
        await tester.pump();

        expect(find.text('server_error'), findsOneWidget);
        await tester.pump(const Duration(seconds: 3));
      });
    });

    group('golden', () {
      testWidgets('matches initial state', (tester) async {
        final router = _buildRequestEmailRouter(cubit);
        addTearDown(router.dispose);

        await pumpRouterApp(tester, router: router);
        await tester.tap(find.text('Open request email'));
        await tester.pumpAndSettle();

        await expectGolden(tester, name: 'auth/request_email_view_initial');
      });

      testWidgets('matches validation error state', (tester) async {
        final router = _buildRequestEmailRouter(cubit);
        addTearDown(router.dispose);

        await pumpRouterApp(tester, router: router);
        await tester.tap(find.text('Open request email'));
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(ElevatedButton, 'Send OTP'));
        await tester.pump();

        await expectGolden(
          tester,
          name: 'auth/request_email_view_validation_error',
        );
      });
    });
  });
}
