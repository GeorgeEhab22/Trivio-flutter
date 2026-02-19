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
import 'package:flutter/material.dart';

class GroupsView extends StatelessWidget {
  const GroupsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                      title: l10n.yourGroups, // Localized
                      onSeeAll: () {
                        DefaultTabController.of(context).animateTo(1);
                      },
                    ),
                    const YourGroupsRowList(),

                    SeeAllHeader(
                      title: l10n.suggestedGroups, // Localized
                      onSeeAll: () {
                        DefaultTabController.of(context).animateTo(2);
                      },
                    ),
                    const SuggestedGroupsRowList(),
                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.fromYourGroups, style: Styles.textStyle18), // Localized
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const GroupsPostsFeed(),
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