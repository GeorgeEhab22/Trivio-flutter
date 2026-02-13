import 'package:auth/core/app_routes.dart';
import 'package:auth/presentation/groups/widgets/suggest_card.dart';
import 'package:auth/presentation/manager/group_cubit/get_groups/get_groups_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_groups/get_groups_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DiscoverGroupsListView extends StatelessWidget {
  const DiscoverGroupsListView({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double availableWidth = (screenWidth - 42) / 2;

    return BlocBuilder<GetAllGroupsCubit, GetGroupsState>(
      builder: (context, state) {
        if (state is GetGroupsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GetGroupsFailure) {
          return Center(child: Text(state.message));
        }

        if (state is GetGroupsSuccess) {
          final groups = state.groups;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      "Suggested for you",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final group = groups[index];
                      return SuggestCard(
                        imageUrl: group.groupCoverImage, 
                        groupName: group.groupName,
                        description: group.groupDescription,
                        isRow: false,
                        onJoinGroup: () {
                          context.push(AppRoutes.groupPreview, extra: group.groupId);
                        },
                      );
                    },
                    childCount: groups.length,
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}