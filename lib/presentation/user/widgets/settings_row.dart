import 'package:flutter/material.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/constants/colors.dart';

class SettingsRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onpressed;
  final bool isToggle;

  const SettingsRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onpressed,
    this.isToggle = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return InkWell( 
      onTap: !isToggle ? onpressed : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Row(
          children: [
            Expanded(
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Styles.textStyle18),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: Styles.textStyle16.copyWith(color: AppColors.darkGrey),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (!isToggle)
              Icon(
                isArabic ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right,
                color: AppColors.darkGrey,
              )
            else
              const ToggleSwitch(),
          ],
        ),
      ),
    );
  }
}

class ToggleSwitch extends StatefulWidget {
  const ToggleSwitch({super.key});

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  bool isSwitched = true;

  @override
  Widget build(BuildContext context) {
    return Switch(
      activeThumbColor: AppColors.primary,
      value: isSwitched,
      onChanged: (value) {
        setState(() {
          isSwitched = value;
        });
      },
    );
  }
}