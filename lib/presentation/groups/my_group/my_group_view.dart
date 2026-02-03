import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/groups/group_preview/widgets/group_image.dart';
import 'package:auth/presentation/groups/my_group/widgets/my_group_app_bar.dart';
import 'package:auth/presentation/groups/widgets/number_of_members_row.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyGroupView extends StatelessWidget {
  const MyGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyGroupAppBar(),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GroupImage(),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("My group1", style: Styles.textStyleBold20),
                    const SizedBox(height: 8),
                    const NumberOfMembersRow(),
                    const SizedBox(height: 20),

                    CustomSquareButton(
                      label: "Manage",
                      height: 13,
                      onTap: () {
                        context.push(AppRoutes.manageGroup);
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
                            backgroundColor: Theme.of(context).cardColor,
                            alignment: CrossAxisAlignment.start,
                          ),
                        ),
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
