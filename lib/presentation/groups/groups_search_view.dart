import 'dart:async';
import 'package:auth/domain/entities/group.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/groups/widgets/dummy_for_skeletonizer.dart';
import 'package:auth/presentation/groups/widgets/group_item.dart';
import 'package:auth/presentation/manager/group_cubit/get_groups/get_groups_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_groups/get_groups_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GroupsSearchView extends StatefulWidget {
  const GroupsSearchView({super.key});

  @override
  State<GroupsSearchView> createState() => _GroupsSearchViewState();
}

class _GroupsSearchViewState extends State<GroupsSearchView> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<bool> _showClearIcon = ValueNotifier<bool>(false);
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _showClearIcon.dispose();
    _debounce?.cancel();

    Future.microtask(() {
      if (mounted) {
        context.read<GetAllGroupsCubit>().searchGroups("");
      }
    });

    super.dispose();
  }

  void _onSearchChanged(String query) {
    _showClearIcon.value = query.isNotEmpty;

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), () {
      context.read<GetAllGroupsCubit>().searchGroups(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0, 
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => context.pop(),
        ),
        title: Padding(
          padding: const EdgeInsetsDirectional.only(end: 16),
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              onChanged: _onSearchChanged,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: l10n.searchGroupsHint,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
                border: InputBorder.none,
                prefixIcon: const Icon(
                  Icons.search,
                  size: 22,
                  color: Colors.grey,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                suffixIcon: ValueListenableBuilder<bool>(
                  valueListenable: _showClearIcon,
                  builder: (context, hasText, child) {
                    return hasText
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged("");
                            },
                          )
                        : const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<GetAllGroupsCubit, GetAllGroupsState>(
        builder: (context, state) {
          final cubit = context.read<GetAllGroupsCubit>();
          final bool isInitialLoading =
              state is GetAllGroupsLoading && cubit.items.isEmpty;
          final bool isLoadingMore = state is GetAllGroupsLoadingMore;

          if (cubit.items.isEmpty && !isInitialLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noGroupsFound,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final List<Group> displayGroups = isInitialLoading
              ? DummyData.dummyGroups
              : [...cubit.items, if (isLoadingMore) DummyData.dummyGroup];

          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification &&
                  notification.metrics.pixels >=
                      notification.metrics.maxScrollExtent * 0.8) {
                cubit.loadData();
              }
              return false;
            },
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: displayGroups.length,
              itemBuilder: (context, index) {
                final group = displayGroups[index];
                return Skeletonizer(
                  enabled: isInitialLoading || group.groupId.isEmpty,
                  child: GroupItem(
                    groupId: group.groupId,
                    title: group.groupName,
                    imageUrl: group.groupCoverImage,
                    numOfMembers:
                        (group.membersCount ?? 0) + (group.adminsCount ?? 0),
                    isHorizontal: true,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}