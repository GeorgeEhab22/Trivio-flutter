import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/groups/group_feed/widgets/group_feed_app_bar.dart';
import 'package:auth/presentation/groups/group_feed/widgets/leave_group_button.dart';
import 'package:auth/presentation/groups/group_preview/widgets/group_image.dart';
import 'package:auth/presentation/groups/widgets/common_group_buttom_sheet.dart';
import 'package:auth/presentation/groups/widgets/dummy_for_skeletonizer.dart';
import 'package:auth/presentation/groups/widgets/number_of_members_row.dart';
import 'package:auth/presentation/manager/group_cubit/get_group/get_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_group/get_group_state.dart';
import 'package:auth/presentation/manager/group_cubit/leave_group/leave_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/leave_group/leave_group_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GroupFeedView extends StatelessWidget {
  final String groupId;
  const GroupFeedView({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LeaveGroupCubit, LeaveGroupState>(
      listener: (context, state) {
        if (state is LeaveGroupSuccess) {
          // showCustomSnackBar(context, "Left group successfully", true);
          context.go(AppRoutes.groupPreview, extra: groupId);
        }
        if (state is LeaveGroupFailure) {
          showCustomSnackBar(context, state.message, false);
        }
      },
      child: Scaffold(
        appBar: const GroupFeedAppBar(),
        body: BlocBuilder<GetGroupCubit, GetGroupState>(
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
                      GroupImage(image: group.groupCoverImage),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.groupName,
                              style: Styles.textStyleBold20,
                            ),
                            const SizedBox(height: 8),
                            NumberOfMembersRow(
                              numOfMembers:
                                  group.membersCount! +
                                  group.moderatorsCount! +
                                  group.adminsCount!,
                            ),
                            const SizedBox(height: 20),

                            CustomSquareButton(
                              label: "Joined",
                              height: 13,
                              onTap: () {
                                final leaveGroupCubit = context
                                    .read<LeaveGroupCubit>();
                                showCommonGroupBottomSheet(
                                  context: context,
                                  actions: [
                                    BlocProvider.value(
                                      value: leaveGroupCubit,
                                      child: LeaveGroupButton(
                                        groupId: group.groupId,
                                      ),
                                    ),
                                  ],
                                );
                              },
                              row: true,
                              isExpanded: true,
                              trailingIcon: Icons.arrow_drop_down_outlined,
                              leadingIcon: Icons.groups,
                              backgroundColor: Theme.of(context).cardColor,
                              textStyle: Styles.textStyle16,
                            ),
                            const SizedBox(height: 20),

                            Row(
                              children: [
                                //TODO change to actual user image
                                const CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(
                                    'https://picsum.photos/500',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: CustomSquareButton(
                                    onTap: () {},
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
                                // SizedBox(width: ),
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
                            const SizedBox(height: 12),
                            //TODO: show posts of group here
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
