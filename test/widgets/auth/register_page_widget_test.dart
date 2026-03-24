import 'package:auth/core/errors/failure.dart';
import 'package:auth/presentation/authentication/register/register_view.dart';
import 'package:auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixtures/auth_test_data.dart';
import '../../helpers/golden_test_config.dart';
import '../../helpers/widget_test_harness.dart';
import '../../mocks/auth_usecase_mocks.dart';

void main() {
  group('RegisterPage widget tests', () {
    late MockRegisterUseCase registerUseCase;
    late RegisterCubit cubit;

    setUp(() {
      registerUseCase = MockRegisterUseCase();
      stubRegisterFailure(registerUseCase);
      cubit = RegisterCubit(registerUseCase: registerUseCase);
    });

    tearDown(() async {
      await cubit.close();
    });

    group('render', () {
      testWidgets('renders core controls and labels', (tester) async {
        await pumpApp(
          tester,
          BlocProvider<RegisterCubit>.value(
            value: cubit,
            child: const RegisterPage(),
          ),
        );

        expect(find.text('Create Account'), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'Username'), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
        expect(
          find.widgetWithText(ElevatedButton, 'Send code'),
          findsOneWidget,
        );
      });
    });

    group('interaction', () {
      testWidgets('shows validation errors when submitting empty form', (
        tester,
      ) async {
        await pumpApp(
          tester,
          BlocProvider<RegisterCubit>.value(
            value: cubit,
            child: const RegisterPage(),
          ),
        );

        await tester.tap(find.widgetWithText(ElevatedButton, 'Send code'));
        await tester.pumpAndSettle();

        expect(find.text('Username is required'), findsOneWidget);
        expect(find.text('Please enter your email'), findsOneWidget);
        expect(find.text('Password is required'), findsOneWidget);
        expect(find.text('Please confirm your password'), findsOneWidget);
        verifyNever(
          () => registerUseCase(
            email: any(named: 'email'),
            username: any(named: 'username'),
            password: any(named: 'password'),
            confirmPassword: any(named: 'confirmPassword'),
          ),
        );
      });

      testWidgets('submits valid form and shows localized auth error', (
        tester,
      ) async {
        stubRegisterFailure(
          registerUseCase,
          failure: const AuthFailure('email_taken'),
        );

        await pumpApp(
          tester,
          BlocProvider<RegisterCubit>.value(
            value: cubit,
            child: const RegisterPage(),
          ),
          settle: false,
        );

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Username'),
          kValidUsername,
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'),
          kValidEmail,
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Password').first,
          kValidPassword,
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Confirm Password'),
          kValidPassword,
        );
        await tester.tap(find.widgetWithText(ElevatedButton, 'Send code'));
        await tester.pumpAndSettle();

        verify(
          () => registerUseCase(
            email: kValidEmail,
            username: kValidUsername,
            password: kValidPassword,
            confirmPassword: kValidPassword,
          ),
        ).called(1);
        expect(find.text('This email is already in use.'), findsOneWidget);
        await tester.pump(const Duration(seconds: 3));
      });
    });

    group('golden', () {
      testWidgets('matches initial state', (tester) async {
        await pumpApp(
          tester,
          BlocProvider<RegisterCubit>.value(
            value: cubit,
            child: const RegisterPage(),
          ),
        );

        await expectGolden(tester, name: 'auth/register_page_initial');
      });

      testWidgets('matches empty-form validation state', (tester) async {
        await pumpApp(
          tester,
          BlocProvider<RegisterCubit>.value(
            value: cubit,
            child: const RegisterPage(),
          ),
        );

        await tester.tap(find.widgetWithText(ElevatedButton, 'Send code'));
        await tester.pumpAndSettle();

        await expectGolden(tester, name: 'auth/register_page_validation_error');
      });
    });
  });
}
