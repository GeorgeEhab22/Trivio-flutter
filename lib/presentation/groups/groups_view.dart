import 'package:auth/common/functions/see_all_header.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/groups/discover_groups_list_view.dart';
import 'package:auth/presentation/groups/my_groups_list_view.dart';
import 'package:auth/presentation/groups/widgets/groups_app_bar.dart';
import 'package:auth/presentation/groups/widgets/suggested_row_list.dart';
import 'package:auth/presentation/groups/widgets/your_groups_row_list.dart';
import 'package:auth/presentation/groups/joined_groups_list_view.dart';
import 'package:flutter/material.dart';

class GroupsView extends StatelessWidget {
  const GroupsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: const GroupsAppBar(),
        body: Builder(
          builder: (context) {
            return TabBarView(
              children: [
                ListView(
                  padding: const EdgeInsets.only(top: 8, left: 8.0),
                  children: [
                    SeeAllHeader(
                      title: "Your groups",
                      onSeeAll: () {
                        DefaultTabController.of(context).animateTo(1);
                      },
                    ),
                    const YourGroupsRowList(),

                    SeeAllHeader(
                      title: "Suggested groups",
                      onSeeAll: () {
                        DefaultTabController.of(context).animateTo(2);
                      },
                    ),
                    const SuggestedGroupsRowList(),
                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("From your groups", style: Styles.textStyle18),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    //TODO: Add posts from user's groups
                  ],
                ),

                const JoinedGroupsListView(),
                const DiscoverGroupsListView(),
                const MyGroupsListView(),
              ],
            );
          },
        ),
      ),
    );
  }
}
