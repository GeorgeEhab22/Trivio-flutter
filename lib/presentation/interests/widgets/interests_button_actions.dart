import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/profile_cubit/interests/select_interests_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/interests/select_interests_state.dart';
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

    return BlocBuilder<SelectInterestsCubit, SelectInterestsState>(
      builder: (context, state) {
        bool enableButton = false;
        bool isSubmitting = state is InterestsSubmittingState;

        if (state is InterestsContentState) {
          if (isEdit) {
            enableButton = state.hasChanges;
          } else if (isTeams) {
            enableButton = true;
          } else {
            enableButton =
                state.selectedTeams.isNotEmpty ||
                state.selectedPlayers.isNotEmpty;
          }
        }

        if (isEdit) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomSquareButton(
                  label: l10n.update,
                  row: true,
                  height: 11,
                  isLoading: isSubmitting,
                  backgroundColor: enableButton
                      ? AppColors.primary.withValues(alpha: 0.9)
                      : Theme.of(context).cardColor,
                  onTap: enableButton
                      ? () async {
                          final success = await cubit.submitInterests();
                          if (success && context.mounted) {
                            context.pop();
                          }
                        }
                      : null,
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
                row: true,
                height: 11,
                backgroundColor: Theme.of(context).cardColor,
                onTap: () {
                  if (isTeams) {
                    showCustomSnackBar(context, l10n.welcomeBack, true);
                    context.go(AppRoutes.home);
                  } else {
                    context.pop();
                  }
                },
              ),
              CustomSquareButton(
                label: isTeams ? l10n.next : l10n.finish,
                row: true,
                height: 11,
                isLoading: isSubmitting && !isTeams,
                backgroundColor: enableButton
                    ? AppColors.primary.withValues(alpha: 0.9)
                    : Theme.of(context).cardColor,
                onTap: enableButton
                    ? () async {
                        if (isTeams) {
                          context.push(AppRoutes.selectPlayers);
                        } else {
                          final success = await cubit.submitInterests();
                          if (success && context.mounted) {
                            showCustomSnackBar(context, l10n.welcomeBack, true);
                            context.go(AppRoutes.home);
                          }
                        }
                      }
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
