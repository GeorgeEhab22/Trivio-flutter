import 'package:auth/common/functions/see_all_header.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/groups/discover_groups_list_view.dart';
import 'package:auth/presentation/groups/my_groups_list_view.dart';
import 'package:auth/presentation/groups/widgets/groups_app_bar.dart';
import 'package:auth/presentation/groups/widgets/groups_posts_feed.dart';
import 'package:auth/presentation/groups/widgets/suggested_row_list.dart';
import 'package:auth/presentation/groups/widgets/your_groups_row_list.dart';
import 'package:auth/presentation/groups/joined_groups_list_view.dart';
import 'package:auth/presentation/manager/group_cubit/get_group_posts/group_posts_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupsView extends StatelessWidget {
  const GroupsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 4,
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: const GroupsAppBar(),
            body: TabBarView(
              children: [
                NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo is ScrollUpdateNotification &&
                        (scrollInfo.scrollDelta ?? 0) > 0 &&
                        scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent * 0.8) {
                      context.read<GroupPostsCubit>().loadMoreFeedPosts();
                    }
                    return false;
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SeeAllHeader(
                                title: l10n.yourGroups,
                                onSeeAll: () => DefaultTabController.of(
                                  context,
                                ).animateTo(1),
                              ),
                              const YourGroupsRowList(),
                              SeeAllHeader(
                                title: l10n.suggestedGroups,
                                onSeeAll: () => DefaultTabController.of(
                                  context,
                                ).animateTo(2),
                              ),
                              const SuggestedGroupsRowList(),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Text(
                                  l10n.fromYourGroups,
                                  style: Styles.textStyle18,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                      const GroupsPostsFeed(),
                    ],
                  ),
                ),
                const JoinedGroupsListView(),
                const DiscoverGroupsListView(),
                const MyGroupsListView(),
              ],
            ),
          );
        },
      ),
    );
  }
}
