import 'package:auth/core/styels.dart';
import 'package:auth/presentation/groups/group_preview/widgets/group_image.dart';
import 'package:auth/presentation/groups/group_preview/widgets/group_preview_app_bar.dart';
import 'package:auth/presentation/groups/group_preview/widgets/join_group_button.dart';
import 'package:auth/presentation/groups/group_preview/widgets/private_row.dart';
import 'package:auth/presentation/groups/widgets/dummy_for_skeletonizer.dart';
import 'package:auth/presentation/groups/widgets/number_of_members_row.dart';
import 'package:auth/presentation/home/widgets/exbandable_text.dart';
import 'package:auth/presentation/manager/group_cubit/get_group/get_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_group/get_group_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GroupPreviewView extends StatelessWidget {
  const GroupPreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GroupPreviewAppBar(),
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GroupImage(image: group.groupCoverImage),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(group.groupName, style: Styles.textStyleBold20),
                          const SizedBox(height: 8),
                          NumberOfMembersRow(
                            numOfMembers:
                                group.membersCount! +
                                group.moderatorsCount! +
                                group.adminsCount!,
                          ),
                          const SizedBox(height: 20),
                          JoinGroupButton(groupId:group.groupId),
                          const SizedBox(height: 20),
              
                          const Text("About", style: Styles.textStyleBold18),
                          const SizedBox(height: 12),
                          ExpandableText(
                            text: group.groupDescription,
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
          
        },
      ),
    );
  }
}
