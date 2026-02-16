import 'package:auth/presentation/manager/locale_cubit/locale_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageSwitchButton extends StatelessWidget {
  const LanguageSwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        final isEnglish = locale.languageCode == 'en';
        
        return TextButton.icon(
          onPressed: () => context.read<LocaleCubit>().toggleLocale(),
          icon: const Icon(Icons.language, size: 20),
          label: Text(
            isEnglish ? 'العربية' : 'English',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          style: TextButton.styleFrom(
            foregroundColor: isDarkMode ? Colors.white : Colors.black87,
          ),
        );
      },
    );
  }
}