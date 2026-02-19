import 'package:auth/constants/colors.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class PeopleTabBar extends StatelessWidget implements PreferredSizeWidget {
  
  const PeopleTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,

      splashFactory: NoSplash.splashFactory,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      labelPadding: const EdgeInsets.symmetric(horizontal: 0),

      indicatorSize: TabBarIndicatorSize.label,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
      ),

      labelColor: AppColors.primary,
      unselectedLabelColor: isDark ? Colors.grey[400] : Colors.grey[700],

      // Changed to EdgeInsetsDirectional to handle RTL (Arabic) correctly
      padding: const EdgeInsetsDirectional.only(start: 8, bottom: 8),
      tabs: [
        buildTab(l10n.members, isDark),
        buildTab(l10n.moderators, isDark),
        buildTab(l10n.admins, isDark),
      ],
    );
  }

  Widget buildTab(String label, bool isDark) {
    return Tab(
      height: 35,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}