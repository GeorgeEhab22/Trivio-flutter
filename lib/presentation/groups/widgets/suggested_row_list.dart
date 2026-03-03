import 'package:auth/core/app_routes.dart';
import 'package:auth/presentation/groups/widgets/dummy_for_skeletonizer.dart';
import 'package:auth/presentation/groups/widgets/suggest_card.dart';
import 'package:auth/presentation/manager/group_cubit/get_groups/get_groups_cubit.dart';
import 'package:auth/presentation/manager/groups_pagination/pagination_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SuggestedGroupsRowList extends StatelessWidget {
  const SuggestedGroupsRowList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAllGroupsCubit, PaginationState>(
      builder: (context, state) {
        final cubit = context.read<GetAllGroupsCubit>();
        final bool isInitialLoading =
            state is PaginationLoading && cubit.items.isEmpty;

        final groups = isInitialLoading ? DummyData.dummyGroups : cubit.items;

        if (state is PaginationError && cubit.items.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: groups.length > 6 ? 5 : groups.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final group = groups[index];
              return Skeletonizer(
                enabled: isInitialLoading || group.groupId.isEmpty,
                child: SuggestCard(
                  groupName: group.groupName,
                  description: group.groupDescription,
                  imageUrl: group.groupCoverImage,
                  onJoinGroup: () => context.push(
                    '${AppRoutes.groupPreview}/${group.groupId}',
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
