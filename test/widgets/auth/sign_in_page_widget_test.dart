import 'package:auth/core/errors/failure.dart';
import 'package:auth/presentation/authentication/signIn/sign_in_view.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/sign_in_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixtures/auth_test_data.dart';
import '../../helpers/golden_test_config.dart';
import '../../helpers/widget_test_harness.dart';
import '../../mocks/auth_usecase_mocks.dart';

void main() {
  group('SignInPage widget tests', () {
    late MockSignInUseCase signInUseCase;
    late MockGoogleSignInAndRegisterUseCase googleUseCase;
    late SignInCubit cubit;

    setUp(() {
      signInUseCase = MockSignInUseCase();
      googleUseCase = MockGoogleSignInAndRegisterUseCase();
      stubGoogleSignInSuccess(googleUseCase);
      stubSignInFailure(signInUseCase);

      cubit = SignInCubit(
        signInUseCase: signInUseCase,
        googleSignInUseCase: googleUseCase,
      );
    });

    tearDown(() async {
      await cubit.close();
    });

    group('render', () {
      testWidgets('renders core controls and labels', (tester) async {
        await pumpApp(
          tester,
          BlocProvider<SignInCubit>.value(
            value: cubit,
            child: const SignInPage(),
          ),
        );

        expect(find.text('Sign In'), findsNWidgets(2));
        expect(
          find.widgetWithText(TextFormField, 'Username or Email'),
          findsOneWidget,
        );
        expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
        expect(find.text('Sign in with Google'), findsOneWidget);
      });
    });

    group('interaction', () {
      testWidgets('shows validation errors when submitting empty form', (
        tester,
      ) async {
        await pumpApp(
          tester,
          BlocProvider<SignInCubit>.value(
            value: cubit,
            child: const SignInPage(),
          ),
        );

        await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
        await tester.pumpAndSettle();

        expect(
          find.text('Please enter your username or email'),
          findsOneWidget,
        );
        expect(find.text('Password is required'), findsOneWidget);
        verifyNever(
          () => signInUseCase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        );
      });

      testWidgets('submits valid credentials and shows localized error state', (
        tester,
      ) async {
        stubSignInFailure(
          signInUseCase,
          failure: const AuthFailure('invalid_credentials'),
        );

        await pumpApp(
          tester,
          BlocProvider<SignInCubit>.value(
            value: cubit,
            child: const SignInPage(),
          ),
          settle: false,
        );

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Username or Email'),
          kValidEmail,
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'),
          kValidPassword,
        );
        await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
        await tester.pumpAndSettle();

        verify(
          () => signInUseCase(email: kValidEmail, password: kValidPassword),
        ).called(1);
        expect(find.text('invalid_credentials'), findsOneWidget);
        await tester.pump(const Duration(seconds: 3));
      });
    });

    group('golden', () {
      testWidgets('matches initial state', (tester) async {
        await pumpApp(
          tester,
          BlocProvider<SignInCubit>.value(
            value: cubit,
            child: const SignInPage(),
          ),
        );

        await expectGolden(tester, name: 'auth/sign_in_page_initial');
      });

      testWidgets('matches empty-form validation state', (tester) async {
        await pumpApp(
          tester,
          BlocProvider<SignInCubit>.value(
            value: cubit,
            child: const SignInPage(),
          ),
        );

        await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
        await tester.pumpAndSettle();

        await expectGolden(tester, name: 'auth/sign_in_page_validation_error');
      });
    });
  });
}
