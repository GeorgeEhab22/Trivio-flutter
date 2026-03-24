import 'package:auth/core/app_routes.dart';
import 'package:auth/presentation/manager/theme_cubit/theme_cubit.dart';
import 'package:auth/presentation/settings/theme_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/golden_test_config.dart';
import '../../helpers/widget_test_harness.dart';

Future<ThemeCubit> _buildThemeCubit({String savedThemeMode = 'system'}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    'language_code': 'en',
    'theme_mode': savedThemeMode,
  });
  final prefs = await SharedPreferences.getInstance();
  return ThemeCubit(prefs);
}

GoRouter _buildThemeRouter(ThemeCubit cubit) {
  return GoRouter(
    initialLocation: '/host',
    routes: <RouteBase>[
      GoRoute(
        path: '/host',
        builder: (context, state) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => context.push(AppRoutes.theme),
              child: const Text('Open theme'),
            ),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.theme,
        builder: (context, state) => BlocProvider<ThemeCubit>.value(
          value: cubit,
          child: const ThemeView(),
        ),
      ),
    ],
  );
}

void main() {
  group('ThemeView widget tests', () {
    group('render', () {
      testWidgets('renders dark mode options', (tester) async {
        final cubit = await _buildThemeCubit();
        final router = _buildThemeRouter(cubit);
        addTearDown(() async {
          router.dispose();
          await cubit.close();
        });

        await pumpRouterApp(tester, router: router);
        await tester.tap(find.text('Open theme'));
        await tester.pumpAndSettle();

        expect(find.text('Dark mode'), findsOneWidget);
        expect(find.text('On'), findsOneWidget);
        expect(find.text('Off'), findsOneWidget);
        expect(find.text('System default'), findsOneWidget);
      });
    });

    group('interaction', () {
      testWidgets('selecting On sets dark mode', (tester) async {
        final cubit = await _buildThemeCubit(savedThemeMode: 'system');
        final router = _buildThemeRouter(cubit);
        addTearDown(() async {
          router.dispose();
          await cubit.close();
        });

        await pumpRouterApp(tester, router: router);
        await tester.tap(find.text('Open theme'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('On'));
        await tester.pump(const Duration(milliseconds: 60));
        expect(cubit.state.isAnimating, isTrue);
        await tester.pump(const Duration(milliseconds: 500));
        expect(cubit.state.mode, ThemeMode.dark);
        expect(cubit.state.isAnimating, isFalse);
      });

      testWidgets('selecting Off sets light mode', (tester) async {
        final cubit = await _buildThemeCubit(savedThemeMode: 'dark');
        final router = _buildThemeRouter(cubit);
        addTearDown(() async {
          router.dispose();
          await cubit.close();
        });

        await pumpRouterApp(tester, router: router);
        await tester.tap(find.text('Open theme'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Off'));
        await tester.pump(const Duration(milliseconds: 560));
        expect(cubit.state.mode, ThemeMode.light);
      });

      testWidgets('back button pops to previous route', (tester) async {
        final cubit = await _buildThemeCubit();
        final router = _buildThemeRouter(cubit);
        addTearDown(() async {
          router.dispose();
          await cubit.close();
        });

        await pumpRouterApp(tester, router: router);
        await tester.tap(find.text('Open theme'));
        await tester.pumpAndSettle();
        expect(find.text('Dark mode'), findsOneWidget);

        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();
        expect(find.text('Open theme'), findsOneWidget);
      });
    });

    group('golden', () {
      testWidgets('matches system default state', (tester) async {
        final cubit = await _buildThemeCubit(savedThemeMode: 'system');
        final router = _buildThemeRouter(cubit);
        addTearDown(() async {
          router.dispose();
          await cubit.close();
        });

        await pumpRouterApp(tester, router: router);
        await tester.tap(find.text('Open theme'));
        await tester.pumpAndSettle();

        await expectGolden(tester, name: 'settings/theme_view_system');
      });

      testWidgets('matches dark-selected state', (tester) async {
        final cubit = await _buildThemeCubit(savedThemeMode: 'dark');
        final router = _buildThemeRouter(cubit);
        addTearDown(() async {
          router.dispose();
          await cubit.close();
        });

        await pumpRouterApp(
          tester,
          router: router,
          theme: ThemeData.dark(useMaterial3: true),
        );
        await tester.tap(find.text('Open theme'));
        await tester.pumpAndSettle();

        await expectGolden(tester, name: 'settings/theme_view_dark_selected');
      });
    });
  });
}
