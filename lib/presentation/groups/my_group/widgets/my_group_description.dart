import 'package:auth/common/functions/custom_list_tile.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/groups/widgets/common_group_buttom_sheet.dart';
import 'package:auth/presentation/home/widgets/exbandable_text.dart';
import 'package:auth/presentation/manager/group_cubit/get_group/get_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/update_group/update_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/update_group/update_group_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MyGroupDescription extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String? groupDescription;

  const MyGroupDescription({
    super.key,
    required this.groupId,
    required this.groupName,
    this.groupDescription,
  });

  @override
  State<MyGroupDescription> createState() => _MyGroupDescriptionState();
}

class _MyGroupDescriptionState extends State<MyGroupDescription> {
  late TextEditingController descController;
  late FocusNode descFocusNode;
  bool isEditingDesc = false;

  @override
  void initState() {
    super.initState();
    descController = TextEditingController(text: widget.groupDescription);
    descFocusNode = FocusNode();
  }

  @override
  void dispose() {
    descController.dispose();
    descFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateGroupCubit, UpdateGroupState>(
      listener: (context, state) {
        if (state is UpdateGroupSuccess) {
          setState(() => isEditingDesc = false);
          context.read<GetGroupCubit>().getGroup(widget.groupId);
        }
        if (state is UpdateGroupFailure) {
          showCustomSnackBar(context, state.message, false);
        }
      },
      builder: (context, state) {
        bool isLoading = state is UpdateGroupLoading;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("About", style: Styles.textStyle18),
                if (isEditingDesc) const Spacer(),
                const SizedBox(width: 2),
                if (isEditingDesc)
                  _buildEditingActions(isLoading)
                else
                  IconButton(
                    onPressed: () {
                      showCommonGroupBottomSheet(
                        context: context,
                        actions: [
                          CustomListTile(
                            icon: Icons.edit,
                            text: "Edit description",
                            onTap: () {
                              context.pop();
                              setState(() => isEditingDesc = true);
                              descFocusNode.requestFocus();
                            },
                          ),
                        ],
                      );
                    },
                    icon: const Icon(Icons.keyboard_arrow_down),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            isEditingDesc ? _buildTextField() : _buildExpandableText(),
          ],
        );
      },
    );
  }

  Widget _buildEditingActions(bool isLoading) {
    return Row(
      children: [
        IconButton(
          onPressed: isLoading
              ? null
              : () {
                  setState(() => isEditingDesc = false);
                  descController.text = widget.groupDescription ?? "";
                },
          icon: const Icon(Icons.close, color: Colors.red),
        ),
        isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : IconButton(
                onPressed: () {
                  context.read<UpdateGroupCubit>().updateDescription(
                    descController.text.trim(),
                  );
                  context.read<UpdateGroupCubit>().updateGroup(
                    groupId: widget.groupId,
                  );
                },
                icon: const Icon(Icons.check, color: Colors.green),
              ),
      ],
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: descController,
      focusNode: descFocusNode,
      maxLines: null,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildExpandableText() {
    return ExpandableText(
      text: widget.groupDescription ?? "",
      previewLines: 4,
      textStyle: Styles.textStyleNormal15,
    );
  }
}
