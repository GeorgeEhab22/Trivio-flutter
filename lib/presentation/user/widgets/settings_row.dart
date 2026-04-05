import 'package:flutter/material.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/constants/colors.dart';

class SettingsRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? leadingIcon; 
  final VoidCallback? onpressed;
  final bool isToggle;

  const SettingsRow({
    super.key,
    required this.title,
    required this.subtitle,
    this.leadingIcon,
    required this.onpressed,
    this.isToggle = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12), 
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16), 
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.0 : 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: !isToggle ? onpressed : null,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1), 
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    leadingIcon,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
              ],
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Styles.textStyle16.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle, 
                      style: Styles.textStyle14.copyWith(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8, 
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              if (!isToggle)
                Icon(
                  isArabic ? Icons.arrow_back_ios_new_rounded : Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[400],
                  size: 16,
                )
              else
                const ToggleSwitch(),
            ],
          ),
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