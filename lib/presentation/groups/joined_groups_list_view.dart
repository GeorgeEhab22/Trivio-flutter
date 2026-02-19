import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/groups/widgets/dummy_for_skeletonizer.dart';
import 'package:auth/presentation/groups/widgets/group_item.dart';
import 'package:auth/presentation/manager/group_cubit/get_joined_groups/get_joined_groups_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_joined_groups/get_joined_groups_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class JoinedGroupsListView extends StatelessWidget {
  const JoinedGroupsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<GetJoinedGroupsCubit, GetJoinedGroupsState>(
      builder: (context, state) {
        if (state is GetJoinedGroupsEmpty) {
          return SizedBox(
            height: 110,
            child: Center(
              child: Text(
                l10n.noJoinedGroupsYet, // Localized
                style: const TextStyle(color: Colors.grey, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        if (state is GetJoinedGroupsFailure) {
          return Center(child: Text(state.message));
        }
        final bool isLoading = state is GetJoinedGroupsLoading;
        final groups = (state is GetJoinedGroupsSuccess)
            ? state.groups
            : DummyData.dummyGroups;
        return Skeletonizer(
          enabled: isLoading,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: groups.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.search,
                          color: Theme.of(context).iconTheme.color,
                          size: 23,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            l10n.search, // Localized
                            style: Styles.textStyle16.copyWith(
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              final group = groups[index - 1];
              return GroupItem(
                groupId: group.groupId,
                numOfMembers:
                    group.membersCount! +
                    group.moderatorsCount! +
                    group.adminsCount!,
                title: group.groupName,
                imageUrl: group.groupCoverImage,
                isHorizontal: true,
              );
            },
          ),
        );
      },
    );
  }
}