import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/groups/create_group/widgets/text_field_widget.dart';
import 'package:auth/presentation/groups/group_preview/widgets/private_row.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateGroupView extends StatelessWidget {
  const CreateGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.close,
            color: Theme.of(context).iconTheme.color,
            size: 25,
          ),
        ),
        title: const Text("Create group", style: Styles.textStyle18),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text("Name", style: Styles.textStyle18),
                const SizedBox(height: 12),
                textFieldWidget(hint: "Name your group"),

                const SizedBox(height: 24),
                const Divider(thickness: 0.5),
                const SizedBox(height: 12),

                const Text("Description", style: Styles.textStyle18),
                const SizedBox(height: 12),
                textFieldWidget(
                  hint: "Tell people what this group is about",
                  maxLines: 5,
                ),
                const SizedBox(height: 24),
                const PrivateRow(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomSquareButton(
              label: "Next",
              backgroundColor: AppColors.primary,
              textColor: Colors.white,
              textStyle: Styles.textStyle16,
              isExpanded: true,
              onTap: () {
                context.push(AppRoutes.addCoverPhoto);
              },
              // isExpanded: true,
            ),
          ),
        ],
      ),
    );
  }
}
