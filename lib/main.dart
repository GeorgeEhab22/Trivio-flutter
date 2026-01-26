import 'dart:io';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_router.dart';
import 'package:auth/presentation/manager/theme_cubit/theme_cubit.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await dotenv.load(fileName: ".env");
  // Only uncomment this when you want to skip login during development
  await _setupDevMode();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  final bool isLoggedIn = token != null && token.isNotEmpty;
  final bool isDesktop =
      !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
  final bool enableDevicePreview = !kReleaseMode && (isDesktop || kIsWeb);
  runApp(
    DevicePreview(
      enabled: enableDevicePreview,
      builder: (context) =>  MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    final router = createRouter(isLoggedIn);
    
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
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.black87),
              ),
              
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              useMaterial3: true,
              scaffoldBackgroundColor: const Color(0xFF18191a),
              appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF18191a)),
              iconTheme: const IconThemeData(color: Colors.white),
              cardColor: Colors.grey[850],
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.white),
              ),
              
            ),
            routerConfig: router,
          );
        },
      ),
    );
  }
}
Future<void> _setupDevMode() async {
  final prefs = await SharedPreferences.getInstance();
  
  // 1. Paste your long JWT string here
  const String devToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5NzYwMzhmNTE5ZjRkNDE5MzVlMzRiMiIsInVzZXJuYW1lIjoiR2VvcmdlIiwiZW1haWwiOiJnZW9yZ2VlaGFiLmNzQGdtYWlsLmNvbSIsImlhdCI6MTc2OTM0NzY2MiwiZXhwIjoxNzY5NDM0MDYyfQ.Dyx8rlY_dHAsQ1FMrnZ023K4yUOtdsg7F1Prt8Z_UEc"; 

  await prefs.setString('auth_token', devToken);
  
  print("🛠️ DEV MODE: Token injected. App will start as logged in.");
}