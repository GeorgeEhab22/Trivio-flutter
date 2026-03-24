import 'package:auth/core/app_routes.dart';
import 'package:auth/presentation/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../helpers/golden_test_config.dart';
import '../../helpers/widget_test_harness.dart';

GoRouter _buildSettingsRouter({String initialLocation = AppRoutes.settings}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: <RouteBase>[
      GoRoute(
        path: '/host',
        builder: (context, state) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => context.push(AppRoutes.settings),
              child: const Text('Open settings'),
            ),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsView(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('home-screen'))),
      ),
      GoRoute(
        path: AppRoutes.groups,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('groups-screen'))),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('notifications-screen'))),
      ),
      GoRoute(
        path: AppRoutes.theme,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('theme-screen'))),
      ),
      GoRoute(
        path: AppRoutes.blocked,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('blocked-screen'))),
      ),
    ],
  );
}

void main() {
  group('SettingsView widget tests', () {
    group('render', () {
      testWidgets('renders main sections and actions', (tester) async {
        final router = _buildSettingsRouter();
        addTearDown(router.dispose);

        await pumpRouterApp(tester, router: router);

        expect(find.text('Menu'), findsOneWidget);
        expect(find.text('Saved'), findsOneWidget);
        expect(find.text('Groups'), findsOneWidget);
        expect(find.text('Posts'), findsOneWidget);
        expect(find.text('Reels'), findsOneWidget);
        expect(find.text('Notifications'), findsOneWidget);
        expect(find.text('Theme'), findsOneWidget);
        expect(find.text('Blocked'), findsOneWidget);
        expect(find.text('Active status'), findsOneWidget);
      });
    });

    group('interaction', () {
      testWidgets('navigates to groups when tapping groups shortcut', (
        tester,
      ) async {
        final router = _buildSettingsRouter();
        addTearDown(router.dispose);

        await pumpRouterApp(tester, router: router);

        await tester.tap(find.text('Groups'));
        await tester.pumpAndSettle();

        expect(find.text('groups-screen'), findsOneWidget);
      });

      testWidgets('navigates to notifications page from list tile', (
        tester,
      ) async {
        final router = _buildSettingsRouter();
        addTearDown(router.dispose);

        await pumpRouterApp(tester, router: router);

        await tester.tap(find.text('Notifications'));
        await tester.pumpAndSettle();

        expect(find.text('notifications-screen'), findsOneWidget);
      });

      testWidgets('back button goes home when no previous route', (
        tester,
      ) async {
        final router = _buildSettingsRouter();
        addTearDown(router.dispose);

        await pumpRouterApp(tester, router: router);

        await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
        await tester.pumpAndSettle();

        expect(find.text('home-screen'), findsOneWidget);
      });

      testWidgets('back button pops when page was pushed', (tester) async {
        final router = _buildSettingsRouter(initialLocation: '/host');
        addTearDown(router.dispose);

        await pumpRouterApp(tester, router: router);

        await tester.tap(find.text('Open settings'));
        await tester.pumpAndSettle();
        expect(find.text('Menu'), findsOneWidget);

        await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
        await tester.pumpAndSettle();

        expect(find.text('Open settings'), findsOneWidget);
      });
    });

    group('golden', () {
      testWidgets('matches light theme', (tester) async {
        final router = _buildSettingsRouter();
        addTearDown(router.dispose);

        await pumpRouterApp(tester, router: router);
        await expectGolden(tester, name: 'settings/settings_view_light');
      });

      testWidgets('matches dark theme', (tester) async {
        final router = _buildSettingsRouter();
        addTearDown(router.dispose);

        await pumpRouterApp(
          tester,
          router: router,
          theme: ThemeData.dark(useMaterial3: true),
        );
        await expectGolden(tester, name: 'settings/settings_view_dark');
      });
    });
  });
}
