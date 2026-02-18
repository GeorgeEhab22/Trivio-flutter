import 'package:auth/common/functions/bottom_sheet_manager.dart';
import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/presentation/groups/group_preview/widgets/group_image.dart';
import 'package:auth/presentation/manager/group_cubit/update_group/update_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/update_group/update_group_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyGroupCoverImage extends StatelessWidget {
  final String? coverImage;
  final String groupId;

  const MyGroupCoverImage({
    super.key,
    required this.coverImage,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GroupImage(image: coverImage),
        Positioned(
          bottom: 12,
          right: 12,
          child: BlocBuilder<UpdateGroupCubit, UpdateGroupState>(
            builder: (context, state) {
              if (state is UpdateGroupLoading &&
                  context.read<UpdateGroupCubit>().groupCoverImage != null) {
                return const CircleAvatar(
                  radius: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              }
              return CustomSquareButton(
                label: "Edit",
                leadingIcon: Icons.edit,
                height: 9,
                row: true,
                backgroundColor: Theme.of(context).cardColor,
                onTap: () {
                  BottomSheetManager.showMediaSourceSheet(
                    context,
                    false,
                    onPicked: (files) {
                      if (files.isNotEmpty) {
                        context.read<UpdateGroupCubit>().updateImage(
                          files.first,
                        );
                        context.read<UpdateGroupCubit>().updateGroup(
                          groupId: groupId,
                        );
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
