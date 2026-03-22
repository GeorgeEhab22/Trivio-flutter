import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/groups/group_preview/widgets/group_image.dart';
import 'package:auth/presentation/groups/group_preview/widgets/join_group_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SuggestCard extends StatelessWidget {
  final String groupId;
  final String groupName;
  final String? description;
  final String? imageUrl;
  final VoidCallback? onCardTap;
  final VoidCallback? onRemoveSuggestion;
  final bool isRow;
  final bool isMyGroup;

  const SuggestCard({
    super.key,
    required this.groupId,
    required this.groupName,
    this.description,
    this.imageUrl,
    this.onCardTap,
    this.onRemoveSuggestion,
    this.isRow = true,
    required this.isMyGroup,
  });

  @override
  Widget build(BuildContext context) {
    double cardWidth = (MediaQuery.of(context).size.width * (2 / 3)).clamp(
      250,
      300,
    );

    return Padding(
      padding: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
      child: Container(
        width: isRow ? cardWidth : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 0.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: InkWell(
              onTap: onCardTap,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: isRow ? 160 : 120,
                    width: double.infinity,
                    child: GroupImage(image: imageUrl),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          groupName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Styles.textStyle17,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Styles.textStyle14,
                        ),
                        const SizedBox(height: 16),

                        if (isRow)
                          buildRowButtons(context)
                        else
                          buildColumnButtons(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRowButtons(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: isMyGroup
              ? CustomSquareButton(
                  label: l10n.manage,
                  onTap: () => context.push(AppRoutes.manageGroup(groupId)),
                  leadingIcon: Icons.security_outlined,
                  iconColor: Colors.white,
                  row: true,
                  backgroundColor: AppColors.primary,
                  textColor: Colors.white,
                )
              : JoinGroupButton(groupId: groupId, isExpanded: true),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CustomSquareButton(
            label: l10n.remove,
            onTap: onRemoveSuggestion ?? () {},
            backgroundColor: Colors.grey[200],
            textColor: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget buildColumnButtons(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        isMyGroup
            ? CustomSquareButton(
                label: l10n.manage,
                onTap: () => context.push(AppRoutes.manageGroup(groupId)),
                row: true,
                leadingIcon: Icons.security_outlined,
                backgroundColor: AppColors.primary,
                textColor: Colors.white,
                iconColor: Colors.white,
                height: 10,
                textStyle: Styles.textStyle14,
              )
            : JoinGroupButton(
                groupId: groupId,
                isExpanded: true,
                height: 10,
                textStyle: Styles.textStyle14,
              ),
        const SizedBox(height: 8),
        CustomSquareButton(
          label: l10n.remove,
          onTap: onRemoveSuggestion ?? () {},
          backgroundColor: Colors.grey[200],
          textColor: Colors.black,
          height: 10,
        ),
      ],
    );
  }
}
