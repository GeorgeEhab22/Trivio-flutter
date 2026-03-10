import 'package:auth/core/app_routes.dart';
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

class SuggestedGroupsRowList extends StatelessWidget {
  const SuggestedGroupsRowList({super.key});

  @override
  Widget build(BuildContext context) {
    final profileState = context.read<ProfileCubit>().state;
    String myUserId = '';

    if (profileState is ProfileLoaded) {
      myUserId = profileState.user.id;
    }
    return BlocBuilder<GetAllGroupsCubit, GetAllGroupsState>(
      builder: (context, state) {
        final cubit = context.read<GetAllGroupsCubit>();
        final bool isInitialLoading =
            state is GetAllGroupsLoading && cubit.items.isEmpty;

        final groups = isInitialLoading ? DummyData.dummyGroups : cubit.items;

        if (state is GetAllGroupsError && cubit.items.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: isInitialLoading ? 2 : (groups.length > 6 ? 5 : groups.length),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final group = groups[index];
              final bool isMyGroup = group.creatorId == myUserId;
              return Skeletonizer(
                enabled: isInitialLoading || group.groupId.isEmpty,
                child: SuggestCard(
                  groupId: group.groupId,
                  groupName: group.groupName,
                  description: group.groupDescription,
                  imageUrl: group.groupCoverImage,
                  isMyGroup: isMyGroup,
                  onCardTap: isInitialLoading
                      ? null
                      : () => context.push(
                          isMyGroup
                              ? AppRoutes.myGroup(group.groupId)
                              : AppRoutes.groupPreview(group.groupId),
                        ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}