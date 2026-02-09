import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/common/functions/show_custom_dialog.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/group_cubit/cancel_request/cancel_request_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/cancel_request/cancel_request_group_state.dart';
import 'package:auth/presentation/manager/group_cubit/join_group/join_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/join_group/join_group_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// TODO: Sync initial button state (Join/Requested) with actual user membership status from backend on screen initialization

class JoinGroupButton extends StatelessWidget {
  final String groupId;
  final bool isExpanded;
  final double? height;
  final TextStyle? textStyle;

  const JoinGroupButton({
    super.key,
    required this.groupId,
    this.isExpanded = true,
    this.height,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        //join request
        BlocListener<JoinGroupCubit, JoinGroupState>(
          listener: (context, state) {
            if (state is JoinGroupFailure) {
              showCustomSnackBar(context, state.message, false);
            }
          },
        ),
        //cancel request
        BlocListener<CancelRequestGroupCubit, CancelRequestGroupState>(
          listener: (context, state) {
            // if (state is CancelRequestGroupSuccess) {
            //   showCustomSnackBar(
            //     context,
            //     "Request cancelled successfully",
            //     true,
            //   );
            // }
            if (state is CancelRequestGroupFailure) {
              showCustomSnackBar(context, state.message, false);
            }
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          final joinState = context.watch<JoinGroupCubit>().state;
          final cancelState = context.watch<CancelRequestGroupCubit>().state;

          String label = 'Join';
          Color color = AppColors.primary;
          VoidCallback onTap = () {
            context.read<JoinGroupCubit>().joinGroup(groupId: groupId);
          };

          if (joinState is JoinGroupSuccess ||
              cancelState is CancelRequestGroupFailure) {
            label = 'Requested';
            color = Colors.grey;
            onTap = () {
              showCustomDialog(
                context: context,
                title: "Cancel join request",
                content: "Are you sure you want to cancel this request?",
                confirmText: "Cancel Request",
                confirmTextColor: Colors.red,
                onConfirm: () => context
                    .read<CancelRequestGroupCubit>()
                    .cancelRequestGroup(groupId: groupId),
              );
            };
          }
          if (cancelState is CancelRequestGroupSuccess) {
            label = 'Join';
            color = AppColors.primary;
            onTap = () {
              context.read<JoinGroupCubit>().joinGroup(groupId: groupId);
            };
          }
          
          return CustomSquareButton(
            label: label,
            onTap:
                (joinState is JoinGroupLoading ||
                    cancelState is CancelRequestGroupLoading)
                ? () {}
                : onTap,
            backgroundColor: color,
            isExpanded: isExpanded,
            height: height ?? 14,
            textColor: Colors.white,
            textStyle: textStyle ?? Styles.textStyle16,
          );
        },
      ),
    );
  }
}
