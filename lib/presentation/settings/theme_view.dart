import 'package:auth/presentation/manager/theme_cubit/theme_cubit.dart';
import 'package:auth/presentation/settings/widgets/row_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeView extends StatefulWidget {
  const ThemeView({super.key});

  @override
  State<ThemeView> createState() => _ThemeViewState();
}

class _ThemeViewState extends State<ThemeView>
    with SingleTickerProviderStateMixin {
  late AnimationController _rippleController;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  void _onThemeChanged(ThemeMode newMode) {
    _rippleController.forward(from: 0);
    context.read<ThemeCubit>().setThemeMode(newMode);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Dark mode',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: themeState.isAnimating ? 0.7 : 1.0,
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAnimatedOption(
                      context,
                      title: 'On',
                      isSelected: themeState.mode == ThemeMode.dark,
                      onTap: () => _onThemeChanged(ThemeMode.dark),
                      delay: 0,
                    ),
                    _buildAnimatedOption(
                      context,
                      title: 'Off',
                      isSelected: themeState.mode == ThemeMode.light,
                      onTap: () => _onThemeChanged(ThemeMode.light),
                      delay: 50,
                    ),
                    _buildAnimatedOption(
                      context,
                      title: 'System default',
                      isSelected: themeState.mode == ThemeMode.system,
                      onTap: () => _onThemeChanged(ThemeMode.system),
                      delay: 100,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedOption(
    BuildContext context, {
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: isSelected ? 1.0 : 0.98,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubicEmphasized,
            child: rowOption(
              context,
              title: title,
              isSelected: isSelected,
              onTap: onTap,
            ),
          ),
        );
      },
    );
  }
}
