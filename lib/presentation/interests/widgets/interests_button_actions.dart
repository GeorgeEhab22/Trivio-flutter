import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/manager/profile_cubit/interests/select_interests_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class InterestsButtonActions extends StatelessWidget {
  final bool isEdit;
  final bool isTeams;

  const InterestsButtonActions({
    super.key,
    required this.isEdit,
    required this.isTeams,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SelectInterestsCubit>();
    if (isEdit) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomSquareButton(
              label: l10n.update,
              textColor: Colors.white,
              backgroundColor: AppColors.primary.withValues(alpha: 0.9),
              onTap: () =>
                  context.read<SelectInterestsCubit>().submitInterests(),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomSquareButton(
            label: isTeams ? l10n.skip : l10n.back,
            backgroundColor: Theme.of(context).cardColor,
            onTap: () => isTeams ? context.go(AppRoutes.home) : context.pop(),
          ),
          CustomSquareButton(
            label: isTeams ? l10n.next : l10n.finish,
            textColor: Colors.white,
            backgroundColor: AppColors.primary.withValues(alpha: 0.9),
            onTap: () {
              if (isEdit) {
                cubit.submitInterests();
              } else {
                if (isTeams) {
                  context.push(AppRoutes.selectPlayers);
                } else {
                  cubit.submitInterests();
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
