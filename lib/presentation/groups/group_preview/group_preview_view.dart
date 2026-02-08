import 'package:auth/core/styels.dart';
import 'package:auth/presentation/groups/group_preview/widgets/group_image.dart';
import 'package:auth/presentation/groups/group_preview/widgets/group_preview_app_bar.dart';
import 'package:auth/presentation/groups/group_preview/widgets/join_group_button.dart';
import 'package:auth/presentation/groups/group_preview/widgets/private_row.dart';
import 'package:auth/presentation/groups/widgets/number_of_members_row.dart';
import 'package:auth/presentation/home/widgets/exbandable_text.dart';
import 'package:flutter/material.dart';

class GroupPreviewView extends StatelessWidget {
  const GroupPreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GroupPreviewAppBar(),
      body: SingleChildScrollView(
        child: Column(
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
                  const NumberOfMembersRow(),
                  const SizedBox(height: 20),
                  //TODO delete this id when complete get groups use case
                  JoinGroupButton(groupId: "69888500a488d0dae5e0accc"),
                  const SizedBox(height: 20),

                  const Text("About", style: Styles.textStyleBold18),
                  const SizedBox(height: 12),
                  const ExpandableText(
                    text: 'here write group description',
                    previewLines: 4,
                    textStyle: Styles.textStyleNormal15,
                  ),
                  const SizedBox(height: 24),
                  const PrivateRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
