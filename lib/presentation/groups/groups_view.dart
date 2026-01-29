import 'package:auth/common/functions/see_all_header.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/groups/widgets/groups_app_bar.dart';
import 'package:auth/presentation/groups/widgets/suggested_list_view.dart';
import 'package:auth/presentation/groups/widgets/your_groups_list_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroupsView extends StatelessWidget {
  const GroupsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GroupsAppBar(),
      body: ListView(
        padding: const EdgeInsets.only(top: 8,left: 8.0,),
        children: [
          SeeAllHeader(
            title: "Your groups",
            onSeeAll: () => context.push('/your_groups'),
          ),
          const YourGroupsListView(),


          SeeAllHeader(
            title: "Suggested groups",
            onSeeAll: () => context.push('/suggested_groups'),
          ),
          const SuggestedGroupsListView(),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("From your groups", style: Styles.textStyle18)],
            ),
          ),
          const SizedBox(height: 8),
          //TODO: Add posts from user's groups
        ],
      ),
    );
  }
}
