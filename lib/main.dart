import 'dart:io';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_router.dart';
import 'package:auth/core/theme_reveal_animation.dart';
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
      builder: (context) => MyApp(isLoggedIn: isLoggedIn),
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
      create: (_) => di.sl<ThemeCubit>(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return AnimatedTheme(
            data: _getThemeData(themeState.mode, context),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubicEmphasized, // Premium curve
            child: ThemeRevealAnimation(
              themeMode: themeState.mode,
              child: MaterialApp.router(
                title: 'TRIVIO',
                debugShowCheckedModeBanner: false,
                locale: DevicePreview.locale(context),
                builder: (context, child) {
                  // Add smooth overlay transition
                  return Stack(
                    children: [
                      DevicePreview.appBuilder(context, child),
                      if (themeState.isAnimating)
                        _buildThemeTransitionOverlay(themeState.mode),
                    ],
                  );
                },
                themeMode: themeState.mode,
                theme: _lightTheme,
                darkTheme: _darkTheme,
                routerConfig: router,
              ),
            ),
          );
        },
      ),
    );
  }

  ThemeData _getThemeData(ThemeMode mode, BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    if (mode == ThemeMode.system) {
      return brightness == Brightness.dark ? _darkTheme : _lightTheme;
    }
    return mode == ThemeMode.dark ? _darkTheme : _lightTheme;
  }

  Widget _buildThemeTransitionOverlay(ThemeMode targetMode) {
    final isDarkTarget = targetMode == ThemeMode.dark;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: 0,
      curve: Curves.easeInOutCubicEmphasized,
      child: Container(
        color: isDarkTarget ? const Color(0xFF18191a) : Colors.white,
      ),
    );
  }

  ThemeData get _lightTheme => ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
    cardColor: Colors.grey.shade100,
    iconTheme: const IconThemeData(color: AppColors.iconsColor),
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black87)),
  );

  ThemeData get _darkTheme => ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFF18191a),
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF18191a)),
    iconTheme: const IconThemeData(color: Colors.white),
    cardColor: Colors.grey[850],
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
  );
}

Future<void> _setupDevMode() async {
  final prefs = await SharedPreferences.getInstance();

  // 1. Paste your long JWT string here
  const String devToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5NzYwMzhmNTE5ZjRkNDE5MzVlMzRiMiIsInVzZXJuYW1lIjoiR2VvcmdlIiwiZW1haWwiOiJnZW9yZ2VlaGFiLmNzQGdtYWlsLmNvbSIsImlhdCI6MTc3MDY0MDczMH0.DA5cIFKg6zrFN5aailMaZOwgeQIriILXVBVGdJoskpI";

  await prefs.setString('auth_token', devToken);

  print("🛠️ DEV MODE: Token injected. App will start as logged in.");
}

