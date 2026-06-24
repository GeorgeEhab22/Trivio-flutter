import 'package:auth/core/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      context.go(AppRoutes.signIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final shortestSide = MediaQuery.sizeOf(context).shortestSide;
    final animationSize = shortestSide * 0.9;

    final animationColor = const Color.fromARGB(255, 39, 158, 34);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: FractionalTranslation(
          translation: const Offset(-0.14, 0),
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(animationColor, BlendMode.srcIn),
            child: Lottie.asset(
              'assets/animations/splash_animation.json',
              repeat: false,
              width: animationSize,
              height: animationSize,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
