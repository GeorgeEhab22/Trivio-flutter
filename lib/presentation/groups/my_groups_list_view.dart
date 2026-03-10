import 'package:auth/domain/entities/group.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/groups/widgets/dummy_for_skeletonizer.dart';
import 'package:auth/presentation/groups/widgets/group_item.dart';
import 'package:auth/presentation/groups/widgets/group_search_field.dart';
import 'package:auth/presentation/manager/groups_pagination/pagination_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:auth/presentation/manager/group_cubit/get_my_groups/get_my_groups_cubit.dart';

class MyGroupsListView extends StatelessWidget {
  const MyGroupsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<GetMyGroupsCubit, PaginationState>(
      builder: (context, state) {
        final cubit = context.read<GetMyGroupsCubit>();

        if (state is PaginationError && cubit.items.isEmpty) {
          return Center(child: Text(state.message));
        }

        final bool isInitialLoading =
            state is PaginationLoading && cubit.items.isEmpty;
        final bool isLoadingMore = state is PaginationLoadingMore;

        final List<Group> displayGroups = isInitialLoading
            ? DummyData.dummyGroups
            : [...cubit.items, if (isLoadingMore) DummyData.dummyGroup];

        if (state is PaginationLoaded && cubit.items.isEmpty) {
          return Center(child: Text(l10n.noPostsInGroups));
        }

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
                      context.read<GetMyGroupsCubit>().searchGroups(query);
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
                  numOfMembers:group.totalMembers,
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
