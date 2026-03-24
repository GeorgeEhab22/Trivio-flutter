import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/manager/locale_cubit/locale_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Key kWidgetTestSurfaceKey = Key('widget-test-surface');
const Size kDefaultTestSurfaceSize = Size(1280, 1400);

Future<void> pumpApp(
  WidgetTester tester,
  Widget child, {
  List<BlocProvider> providers = const [],
  ThemeData? theme,
  Locale locale = const Locale('en'),
  Size size = kDefaultTestSurfaceSize,
  bool settle = true,
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    'language_code': 'en',
  });
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  final wrappedChild = MultiBlocProvider(
    providers: <BlocProvider>[
      BlocProvider<LocaleCubit>(create: (_) => LocaleCubit()),
      ...providers,
    ],
    child: child,
  );

  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme ?? ThemeData.light(useMaterial3: true),
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, appChild) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: const TextScaler.linear(1)),
          child: RepaintBoundary(key: kWidgetTestSurfaceKey, child: appChild!),
        );
      },
      home: wrappedChild,
    ),
  );

  if (settle) {
    await tester.pumpAndSettle();
  }
}

Future<void> pumpRouterApp(
  WidgetTester tester, {
  required GoRouter router,
  List<BlocProvider> providers = const [],
  ThemeData? theme,
  Locale locale = const Locale('en'),
  Size size = kDefaultTestSurfaceSize,
  bool settle = true,
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    'language_code': 'en',
  });
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: theme ?? ThemeData.light(useMaterial3: true),
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
      builder: (context, appChild) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: const TextScaler.linear(1)),
          child: RepaintBoundary(
            key: kWidgetTestSurfaceKey,
            child: MultiBlocProvider(
              providers: <BlocProvider>[
                BlocProvider<LocaleCubit>(create: (_) => LocaleCubit()),
                ...providers,
              ],
              child: appChild!,
            ),
          ),
        );
      },
    ),
  );

  if (settle) {
    await tester.pumpAndSettle();
  }
}
