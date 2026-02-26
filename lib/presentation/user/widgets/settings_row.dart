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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      child: Row(
        children: [
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Styles.textStyle18),
                SizedBox(height: 5),
                Text(
                  subtitle,
                  style:
                      Styles.textStyle16.copyWith(color: AppColors.darkGrey),
                  softWrap: true,
                ),
              ],
            ),
          ),
          !isToggle
              ? IconButton(
                  onPressed: onpressed,
                  icon: Icon(Icons.keyboard_arrow_right),
                  highlightColor: AppColors.primary,
                  padding: EdgeInsets.zero,
                )
              : ToggleSwitch(),
        ],
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
