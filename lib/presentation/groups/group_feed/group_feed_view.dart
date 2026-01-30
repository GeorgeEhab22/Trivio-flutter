import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/groups/group_feed/widgets/group_feed_app_bar.dart';
import 'package:auth/presentation/groups/group_feed/widgets/leave_group_button.dart';
import 'package:auth/presentation/groups/group_preview/widgets/group_image.dart';
import 'package:auth/presentation/groups/widgets/common_group_buttom_sheet.dart';
import 'package:auth/presentation/groups/widgets/members_row.dart';
import 'package:flutter/material.dart';

class GroupFeedView extends StatelessWidget {
  const GroupFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GroupFeedAppBar(),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GroupImage(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Liverpool", style: Styles.textStyleBold20),
                    const SizedBox(height: 8),
                    const MembersRow(),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: CustomSquareButton(
                        label: "Joined",
                        height: 13,
                        onTap: () {
                          showCommonGroupBottomSheet(
                            context: context,
                            actions: [LeaveGroupButton(),],
                          );
                        },
                        row: true,
                        trailingIcon: Icons.arrow_drop_down_outlined,
                        leadingIcon: Icons.groups,
                        backgroundColor: Theme.of(context).cardColor,
                        isExpanded: false,
                        textStyle: Styles.textStyle16,
                      ),
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
                        CustomSquareButton(
                          onTap: () {},
                          label: "Write something",
                          borderColor: Theme.of(
                            context,
                          ).colorScheme.outlineVariant,
                          borderRadius: 20,
                          height: 12,
                          backgroundColor: Theme.of(context).cardColor,
                          alignment: CrossAxisAlignment.start,
                        ),
                        // SizedBox(width: ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.photo, color: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),

                    const Text("Most relevant", style: Styles.textStyle16),
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
  }
}
