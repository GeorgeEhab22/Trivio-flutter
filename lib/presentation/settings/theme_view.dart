import 'package:auth/presentation/manager/theme_cubit/theme_cubit.dart';
import 'package:auth/presentation/settings/widgets/row_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeView extends StatelessWidget {
  const ThemeView({super.key});

  @override
  Widget build(BuildContext context) {
    // جلب الحالة الحالية للثيم
    final brightness = Theme.of(context).brightness;

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rowOption(
            context,
            title: 'On',
            isSelected: brightness == Brightness.dark,
            onTap: () {
              if (brightness == Brightness.light) {
                context.read<ThemeCubit>().toggleTheme();
              }
            },
          ),
          rowOption(
            context,
            title: 'Off',
            isSelected: brightness == Brightness.light,
            onTap: () {
              if (brightness == Brightness.dark) {
                context.read<ThemeCubit>().toggleTheme();
              }
            },
          ),
          rowOption(
            context,
            title: 'System default',
            isSelected: brightness == Brightness.light,
            onTap: () {
              // TODO: handle system default option
              context.read<ThemeCubit>().toggleTheme();
            },
          ),

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "We'll adjust your appearance based on your device's system settings.",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
