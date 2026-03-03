import 'package:auth/domain/entities/group.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/groups/widgets/dummy_for_skeletonizer.dart';
import 'package:auth/presentation/groups/widgets/group_item.dart';
import 'package:auth/presentation/groups/widgets/group_search_field.dart';
import 'package:auth/presentation/manager/group_cubit/get_joined_groups/get_joined_groups_cubit.dart';
import 'package:auth/presentation/manager/groups_pagination/pagination_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class JoinedGroupsListView extends StatelessWidget {
  const JoinedGroupsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<GetJoinedGroupsCubit, PaginationState>(
      builder: (context, state) {
        final cubit = context.read<GetJoinedGroupsCubit>();

        if (state is PaginationError && cubit.items.isEmpty) {
          return Center(child: Text(state.message));
        }

        if (state is PaginationLoaded && cubit.items.isEmpty) {
          return SizedBox(
            height: 110,
            child: Center(
              child: Text(
                l10n.noJoinedGroupsYet,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final bool isInitialLoading =
            state is PaginationLoading && cubit.items.isEmpty;
        final bool isLoadingMore = state is PaginationLoadingMore;

        final List<Group> displayGroups = isInitialLoading
            ? DummyData.dummyGroups
            : [...cubit.items, if (isLoadingMore) DummyData.dummyGroup];

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo is ScrollUpdateNotification &&
                (scrollInfo.scrollDelta ?? 0) > 0 &&
                scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent * 0.8) {
              cubit.loadData();
            }
            return false;
          },
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: displayGroups.length + 1 + (cubit.hasReachedMax ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GroupSearchField(
                    hintText: l10n.search,
                    onSearch: (query) {
                      context.read<GetJoinedGroupsCubit>().searchGroups(query);
                    },
                  ),
                );
              }
              if (index == displayGroups.length + 1) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(
                    child: Text(
                      l10n.noMoreGroups,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }

              final group = displayGroups[index - 1];

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
                  isHorizontal: true,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
