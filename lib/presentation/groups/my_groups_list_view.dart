import 'package:auth/domain/entities/group.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/groups/widgets/dummy_for_skeletonizer.dart';
import 'package:auth/presentation/groups/widgets/group_item.dart';
import 'package:auth/presentation/groups/widgets/group_search_field.dart';
import 'package:auth/presentation/manager/group_cubit/get_my_groups/get_my_groups_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:auth/presentation/manager/group_cubit/get_my_groups/get_my_groups_cubit.dart';

class MyGroupsListView extends StatelessWidget {
  const MyGroupsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<GetMyGroupsCubit, GetMyGroupsState>(
      builder: (context, state) {
        final cubit = context.read<GetMyGroupsCubit>();

        if (state is GetMyGroupsError && cubit.items.isEmpty) {
          return Center(child: Text(state.message));
        }

        final bool isInitialLoading =
            state is GetMyGroupsLoading && cubit.items.isEmpty;
        final bool isLoadingMore = state is GetMyGroupsLoadingMore;
        final bool isEmptyState = !isInitialLoading && cubit.items.isEmpty;
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
            itemCount: isEmptyState
                ? 2
                : displayGroups.length + 1 ,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GroupSearchField(
                    hintText: l10n.search,
                    onSearch: (query) {
                      context.read<GetMyGroupsCubit>().searchGroups(query);
                    },
                  ),
                );
              }

              if (state is GetMyGroupsError && cubit.items.isEmpty && index == 1) {
                return Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Center(
                    child: Text(state.message, style: const TextStyle(color: Colors.red)),
                  ),
                );
              }

              if (isEmptyState && index == 1) {
                return Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Center(
                    child: Text(
                      l10n.noMyGroupsYet,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              final group = displayGroups[index - 1];

              return Skeletonizer(
                enabled: isInitialLoading || group.groupId.isEmpty,
                child: GroupItem(
                  groupId: group.groupId,
                  numOfMembers: group.membersCount ?? 0,
                  title: group.groupName,
                  imageUrl: group.groupCoverImage,
                  isHorizontal: true,
                  creatorId: group.creatorId,
                ),
              );
            },
          ),
        );
      },
    );
  }
}