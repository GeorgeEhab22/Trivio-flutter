import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/common/functions/show_custom_dialog.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/errors/error_parser.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/group_cubit/cancel_request/cancel_request_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/cancel_request/cancel_request_group_state.dart';
import 'package:auth/presentation/manager/group_cubit/get_group/get_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_groups/get_groups_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/join_group/join_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/join_group/join_group_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JoinGroupButton extends StatelessWidget {
  final String groupId;
  final String? membershipStatus;
  final bool isExpanded;
  final double? height;
  final TextStyle? textStyle;

  const JoinGroupButton({
    super.key,
    required this.groupId,
    this.membershipStatus,
    this.isExpanded = true,
    this.height,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MultiBlocListener(
      listeners: [
        BlocListener<JoinGroupCubit, JoinGroupState>(
          listener: (context, state) {
            if (state is JoinGroupSuccess && state.groupId == groupId) {
              try {
                context.read<GetAllGroupsCubit>().changeMembershipStatusLocally(
                  groupId,
                  'Requested',
                );
              } catch (_) {}
              try {
                context.read<GetGroupCubit>().changeMembershipStatusLocally(
                  'Requested',
                );
              } catch (_) {}
            }
            if (state is JoinGroupFailure && state.groupId == groupId) {
              showCustomSnackBar(context, state.message, false);
            }
          },
        ),
        BlocListener<CancelRequestGroupCubit, CancelRequestGroupState>(
          listener: (context, state) {
            if (state is CancelRequestGroupSuccess &&
                state.groupId == groupId) {
              try {
                context.read<GetAllGroupsCubit>().changeMembershipStatusLocally(
                  groupId,
                  'None',
                );
              } catch (_) {}
              try {
                context.read<GetGroupCubit>().changeMembershipStatusLocally(
                  'None',
                );
              } catch (_) {}
            }
            if (state is CancelRequestGroupFailure &&
                state.groupId == groupId) {
              final msg = ErrorParser.localizeError(context, state.message);
              showCustomSnackBar(context, msg, false);
            }
          },
        ),
      ],
      child: BlocBuilder<JoinGroupCubit, JoinGroupState>(
        builder: (context, joinState) {
          return BlocBuilder<CancelRequestGroupCubit, CancelRequestGroupState>(
            builder: (context, cancelState) {
              String? finalStatus = membershipStatus;

              try {
                final localGroups = context.read<GetAllGroupsCubit>().items;
                final localGroup = localGroups.firstWhere(
                  (g) => g.groupId == groupId,
                );
                finalStatus = localGroup.membershipStatus;
              } catch (_) {}

              bool isRequested = (finalStatus?.toLowerCase() == 'requested');
              bool isMember = (finalStatus?.toLowerCase() == 'member');
              String label = l10n.join;
              Color color = AppColors.primary;
              VoidCallback? onTap = () =>
                  context.read<JoinGroupCubit>().joinGroup(groupId: groupId);

              if (isMember) {
                label = l10n.joined;
                color = Colors.green;
                onTap = null;
              } else if (isRequested) {
                label = l10n.requested;
                color = Colors.grey;
                onTap = () {
                  showCustomDialog(
                    context: context,
                    title: l10n.cancelJoinRequest,
                    content: l10n.cancelJoinRequestContent,
                    confirmText: l10n.cancelRequest,
                    confirmTextColor: Colors.red,
                    onConfirm: () => context
                        .read<CancelRequestGroupCubit>()
                        .cancelRequestGroup(groupId: groupId),
                  );
                };
              }

              bool isLoading =
                  ((joinState is JoinGroupLoading &&
                      joinState.groupId == groupId) ||
                  (cancelState is CancelRequestGroupLoading &&
                      cancelState.groupId == groupId));

              return CustomSquareButton(
                label: label,
                onTap: isLoading ? () {} : onTap,
                backgroundColor: color,
                isExpanded: isExpanded,
                height: height ?? 14,
                textColor: Colors.white,
                textStyle: textStyle ?? Styles.textStyle16,
              );
            },
          );
        },
      ),
    );
  }
}
