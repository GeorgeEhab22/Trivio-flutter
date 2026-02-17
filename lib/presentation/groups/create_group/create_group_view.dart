import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/groups/create_group/widgets/text_field_widget.dart';
import 'package:auth/presentation/groups/group_preview/widgets/private_row.dart';
import 'package:auth/presentation/manager/group_cubit/create_group/create_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/create_group/create_group_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreateGroupView extends StatefulWidget {
  const CreateGroupView({super.key});

  @override
  State<CreateGroupView> createState() => _CreateGroupViewState();
}

class _CreateGroupViewState extends State<CreateGroupView> {
  late TextEditingController nameController;
  late TextEditingController descController;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<CreateGroupCubit>();
    nameController = TextEditingController(text: cubit.name);
    descController = TextEditingController(text: cubit.description);
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateGroupCubit>();
    final state = context.watch<CreateGroupCubit>().state;
    String? nameError;
    String? descError;

    if (state is CreateGroupInitial) {
      nameError = state.nameError;
      descError = state.descError;
    }

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
                textFieldWidget(
                  controller:nameController,
                  hint: "Name your group",
                  errorText: nameError,
                  onChanged: (val) {
                    cubit.updateName(nameController.text);
                    cubit.clearFieldsError();
                  },
                ),

                const SizedBox(height: 24),
                const Divider(thickness: 0.5),
                const SizedBox(height: 12),

                const Text("Description", style: Styles.textStyle18),
                const SizedBox(height: 12),
                textFieldWidget(
                  controller: descController,
                  hint: "Tell people what this group is about",
                  maxLines: 5,
                  errorText: descError,
                  onChanged: (val) {
                    cubit.updateDescription(descController.text);
                    cubit.clearFieldsError();
                  },
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
                if (cubit.validateFields()) {
                  context.push(AppRoutes.addCoverPhoto);
                }
              },
              // isExpanded: true,
            ),
          ),
        ],
      ),
    );
  }
}
