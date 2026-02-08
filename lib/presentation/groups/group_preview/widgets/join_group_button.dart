import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/group_cubit/join_group/join_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/join_group/join_group_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocConsumer<JoinGroupCubit, JoinGroupState>(
      listener: (context, state) {
        if (state is JoinGroupFailure) {
          showCustomSnackBar(context, state.message, false);
        }
      },
      builder: (context, state) {
        String label = 'Join';
        Color color = AppColors.primary;
        VoidCallback? onTap = () {
          context.read<JoinGroupCubit>().joinGroup(groupId: groupId);
        };

        if (state is JoinGroupLoading) {
          label = 'Joining...';
          onTap = null;
        }
        if (state is JoinGroupSuccess) {
          label = 'Requested';
          color = Colors.grey;
          onTap = null;
        }

        return CustomSquareButton(
          label: label,
          onTap: onTap ?? () {},
          backgroundColor: color,
          isExpanded: isExpanded,
          height: height ?? 14,
          textColor: Colors.white,
          textStyle: textStyle ?? Styles.textStyle16,
        );
      },
    );
  }
}
