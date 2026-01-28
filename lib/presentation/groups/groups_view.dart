import 'package:auth/presentation/groups/widgets/groups_app_bar.dart';
import 'package:flutter/material.dart';

class GroupsView extends StatelessWidget {
  const GroupsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GroupsAppBar(),

      body: Center(child: Text('Groups')),
    );
  }
}
