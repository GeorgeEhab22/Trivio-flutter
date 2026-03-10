import 'package:auth/core/app_routes.dart';
import 'package:auth/domain/entities/group.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/groups/widgets/dummy_for_skeletonizer.dart';
import 'package:auth/presentation/groups/widgets/suggest_card.dart';
import 'package:auth/presentation/manager/group_cubit/get_groups/get_groups_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_groups/get_groups_state.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DiscoverGroupsListView extends StatelessWidget {
  const DiscoverGroupsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    double screenWidth = MediaQuery.of(context).size.width;
    double availableWidth = (screenWidth - 42) / 2;

    final profileState = context.read<ProfileCubit>().state;
    String myUserId = ''; 
    
    if (profileState is ProfileLoaded) {
      myUserId = profileState.user.id; 
    }
    return BlocBuilder<GetAllGroupsCubit, GetAllGroupsState>(
      builder: (context, state) {
        final cubit = context.read<GetAllGroupsCubit>();

        if (state is GetAllGroupsError && cubit.items.isEmpty) {
          return Center(child: Text(state.message));
        }

        final bool isInitialLoading =
            state is GetAllGroupsLoading && cubit.items.isEmpty;
        final bool isLoadingMore = state is GetAllGroupsLoadingMore;

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      l10n.suggestedForYou,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: availableWidth / 320,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final group = displayGroups[index];
                    final bool isMyGroup = group.creatorId == myUserId;
                    return Skeletonizer(
                      enabled: isInitialLoading || group.groupId.isEmpty,
                      child: SuggestCard(
                        groupId: group.groupId,
                        imageUrl: group.groupCoverImage,
                        groupName: group.groupName,
                        description: group.groupDescription,
                        isRow: false,
                        isMyGroup:isMyGroup ,
                       onCardTap: isInitialLoading
                            ? null
                            : () => context.push(
                                  isMyGroup 
                                    ? AppRoutes.myGroup(group.groupId) 
                                    : AppRoutes.groupPreview(group.groupId), 
                                ),
                      ),
                    );
                  }, childCount: isInitialLoading ? 4 : displayGroups.length),
                ),
                if (cubit.hasReachedMax && cubit.items.isNotEmpty)
                  const SliverToBoxAdapter(child: SizedBox(height: 50)),
              ],
            ),
          ),
        );
      },
    );
  }
}