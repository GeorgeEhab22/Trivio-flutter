import 'package:auth/constants/colors.dart';
import 'package:auth/domain/entities/reaction.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/common/functions/number_extensions.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/home/reactions/widgets/reaction_type_extention.dart';
import 'package:auth/presentation/home/reactions/widgets/render_reactions.dart';
import 'package:flutter/material.dart';

class ReactionTabBar extends StatelessWidget implements PreferredSizeWidget {
  final int totalReactionsCount;
  final List<ReactionType> sortedTypes;
  final Map<ReactionType, List<Reaction>> reactionsByType;

  const ReactionTabBar({
    super.key,
    required this.totalReactionsCount,
    required this.sortedTypes,
    required this.reactionsByType,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TabBar(
      isScrollable: true,
      physics: const BouncingScrollPhysics(),

      overlayColor: WidgetStateProperty.all(Colors.transparent),

      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorWeight: 0,
      unselectedLabelColor: Theme.of(context).textTheme.bodyMedium!.color,
      dividerColor: isDark
          ? Colors.white12
          : Colors.black.withValues(alpha: 0.05),
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

      tabAlignment: TabAlignment.start,
      tabs: [
        Tab(
          height: 40,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                '${l10n.reactionsTabAll} ${totalReactionsCount.toString().localizeDigits(context)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
        ...sortedTypes.map(
          (type) => Tab(
            height: 40,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ReactionEmoji(path: type.emojiPath, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    reactionsByType[type]!.length.toString().localizeDigits(
                      context,
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
