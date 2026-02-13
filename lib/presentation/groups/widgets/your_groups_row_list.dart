import 'package:auth/presentation/groups/widgets/group_item.dart';
import 'package:auth/presentation/manager/group_cubit/get_groups/get_groups_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_groups/get_groups_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class YourGroupsRowList extends StatelessWidget {
  const YourGroupsRowList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAllGroupsCubit, GetGroupsState>(
      builder: (context, state) {
        if (state is GetGroupsSuccess) {
          final groups = state.groups;
          return SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: groups.length,
              separatorBuilder: (context, index) => const SizedBox(width: 0),
              itemBuilder: (context, index) {
                final group = groups[index];
                //TODO: replace with real group data
                return  GroupItem(
                  groupId: group.groupId,
                  numOfMembers: group.membersCount! +
                      group.moderatorsCount! +
                      group.adminsCount!,
                  title:group.groupName ,
                  imageUrl: group.groupCoverImage,
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
