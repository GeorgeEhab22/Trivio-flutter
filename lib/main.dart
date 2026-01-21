import 'dart:io';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_router.dart';
import 'package:auth/presentation/manager/theme_cubit/theme_cubit.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = createRouter();
    return BlocProvider(
      create: (_) =>di.sl<ThemeCubit> (),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'TRIVIO',
            debugShowCheckedModeBanner: false,
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            themeMode: themeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              useMaterial3: true,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
              cardColor: Colors.grey.shade100,
              iconTheme: const IconThemeData(color: AppColors.iconsColor),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              useMaterial3: true,
              scaffoldBackgroundColor: const Color(0xFF121212),
              appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF1E1E1E)),
              cardColor: const Color(0xFF1E1E1E),
            ),
            routerConfig: router,
          );
        },
      ),
    );
  }
}
