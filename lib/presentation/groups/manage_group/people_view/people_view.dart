import 'package:auth/presentation/groups/manage_group/admins_list_view.dart';
import 'package:auth/presentation/groups/manage_group/members_list_view.dart';
import 'package:auth/presentation/groups/manage_group/moderators_list_view.dart';
import 'package:auth/presentation/groups/manage_group/people_view/widgets/people_app_bar.dart';
import 'package:flutter/material.dart';

class PeopleView extends StatelessWidget {
  final String groupId;
  const PeopleView({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const PeopleAppBar(),
        body: Builder(
          builder: (context) {
            return TabBarView(
              children: [
                MembersListView(groupId: groupId),
                ModeratorsListView(groupId: groupId),
                AdminsListView(groupId: groupId),
              ],
            );
          },
        ),
      ),
    );
  }
}
