import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/groups/widgets/dummy_for_skeletonizer.dart';
import 'package:auth/presentation/groups/widgets/group_item.dart';
import 'package:auth/presentation/manager/group_cubit/get_joined_groups/get_joined_groups_cubit.dart';
import 'package:auth/presentation/manager/groups_pagination/pagination_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class YourGroupsRowList extends StatelessWidget {
  const YourGroupsRowList({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<GetJoinedGroupsCubit, PaginationState>(
      builder: (context, state) {
        final cubit = context.read<GetJoinedGroupsCubit>();
        final bool isInitialLoading =
            state is PaginationLoading && cubit.items.isEmpty;

        if (state is PaginationLoaded && cubit.items.isEmpty) {
          return SizedBox(
            height: 110,
            child: Center(
              child: Text(
                l10n.noJoinedGroupsYet,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          );
        }

        final groups = isInitialLoading ? DummyData.dummyGroups : cubit.items;

        return SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: groups.length,
            separatorBuilder: (context, index) => const SizedBox(width: 0),
            itemBuilder: (context, index) {
              final group = groups[index];
              return Skeletonizer(
                enabled: isInitialLoading || group.groupId.isEmpty,
                child: GroupItem(
                  groupId: group.groupId,
                  numOfMembers:
                      (group.membersCount ?? 0) +
                      (group.moderatorsCount ?? 0) +
                      (group.adminsCount ?? 0),
                  title: group.groupName,
                  imageUrl: group.groupCoverImage,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
