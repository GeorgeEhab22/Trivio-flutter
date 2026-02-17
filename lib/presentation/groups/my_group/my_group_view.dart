import 'package:auth/common/functions/bottom_sheet_manager.dart';
import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/groups/group_preview/widgets/group_image.dart';
import 'package:auth/presentation/groups/my_group/widgets/my_group_app_bar.dart';
import 'package:auth/presentation/groups/my_group/widgets/my_group_description.dart';
import 'package:auth/presentation/groups/widgets/dummy_for_skeletonizer.dart';
import 'package:auth/presentation/groups/widgets/number_of_members_row.dart';
import 'package:auth/presentation/home/add_post/add_post_bottom_sheet.dart';
import 'package:auth/presentation/manager/group_cubit/get_group/get_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_group/get_group_state.dart';
import 'package:auth/presentation/manager/group_cubit/update_group/update_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/update_group/update_group_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyGroupView extends StatelessWidget {
  final String groupId;
  const MyGroupView({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyGroupAppBar(),
      body: BlocListener<UpdateGroupCubit, UpdateGroupState>(
        listener: (context, state) {
          if (state is UpdateGroupSuccess) {
            // context.read<GetGroupCubit>().getGroup(groupId);
            showCustomSnackBar(context, "Update Successful", true);
          }
          if (state is UpdateGroupFailure) {
            showCustomSnackBar(context, state.message, false);
          }
        },
        child: BlocBuilder<GetGroupCubit, GetGroupState>(
          builder: (context, state) {
            if (state is GetGroupFailure) {
              return Center(child: Text(state.message));
            }
            final bool isLoading = state is GetGroupLoading;

            final group = (state is GetGroupSuccess)
                ? state.group
                : DummyData.dummyGroup;

            return Skeletonizer(
              enabled: isLoading,
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(
                        children: [
                          GroupImage(image: group.groupCoverImage),
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child:
                                BlocBuilder<UpdateGroupCubit, UpdateGroupState>(
                                  builder: (context, updateState) {
                                    if (updateState is UpdateGroupLoading &&
                                        context
                                                .read<UpdateGroupCubit>()
                                                .groupCoverImage !=
                                            null) {
                                      return const CircleAvatar(
                                        radius: 18,
                                        backgroundColor: Colors.white,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      );
                                    }
                                    return CustomSquareButton(
                                      label: "Edit",
                                      leadingIcon: Icons.edit,
                                      height: 9,
                                      row: true,
                                      backgroundColor: Theme.of(
                                        context,
                                      ).cardColor,
                                      onTap: () {
                                        BottomSheetManager.showMediaSourceSheet(
                                          context,
                                          false,
                                          onPicked: (files) {
                                            final cubit = context
                                                .read<UpdateGroupCubit>();
                                            if (files.isNotEmpty) {
                                              cubit.updateImage(files.first);
                                              cubit.updateGroup(
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
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    group.groupName,
                                    style: Styles.textStyle25,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Text(
                                    "•",
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    context.push(
                                      AppRoutes.groupMembers,
                                      extra: group.groupId,
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: NumberOfMembersRow(
                                      numOfMembers:
                                          (group.membersCount ?? 0) +
                                          (group.moderatorsCount ?? 0) +
                                          (group.adminsCount ?? 0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            MyGroupDescription(
                              groupId: group.groupId,
                              groupName: group.groupName,
                              groupDescription: group.groupDescription,
                            ),
                            const SizedBox(height: 20),
                            CustomSquareButton(
                              label: "Manage",
                              height: 13,
                              onTap: () {
                                context.push(
                                  AppRoutes.manageGroup,
                                  extra: group.groupId,
                                );
                              },
                              row: true,
                              isExpanded: true,
                              leadingIcon: Icons.security_outlined,
                              backgroundColor: AppColors.primary,
                              textStyle: Styles.textStyle16,
                              textColor: Colors.white,
                              iconColor: Colors.white,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(
                                    'https://picsum.photos/500',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: CustomSquareButton(
                                    onTap: () async {
                                      await showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) =>
                                            AddPostBottomSheet(
                                              groupId: group.groupId,
                                            ),
                                      );
                                    },
                                    label: "Write something",
                                    borderColor: Theme.of(
                                      context,
                                    ).colorScheme.outlineVariant,
                                    borderRadius: 20,
                                    height: 12,
                                    backgroundColor: Theme.of(
                                      context,
                                    ).cardColor,
                                    alignment: CrossAxisAlignment.start,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.photo,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 16),
                            const Text(
                              "Most relevant",
                              style: Styles.textStyle16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
