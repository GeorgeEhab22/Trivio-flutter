import 'package:auth/core/app_routes.dart';
import 'package:auth/presentation/groups/widgets/suggest_card.dart';
import 'package:auth/presentation/manager/group_cubit/get_groups/get_groups_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_groups/get_groups_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SuggestedGroupsRowList extends StatelessWidget {
  const SuggestedGroupsRowList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAllGroupsCubit, GetGroupsState>(
      builder: (context, state) {
        if (state is GetGroupsLoading) {
          return const SizedBox(
            height: 320,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is GetGroupsSuccess) {
          final groups = state.groups;

          return SizedBox(
            height: 320,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: groups.length > 6 ? 5 : groups.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final group = groups[index];
                return SuggestCard(
                  groupName: group.groupName,
                  description: group.groupDescription,
                  imageUrl: group.groupCoverImage,
                  onJoinGroup: () {
                    context.push(AppRoutes.groupPreview, extra: group.groupId);
                  },
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
