import 'package:auth/presentation/groups/manage_group/widgets/member_row.dart';
import 'package:flutter/material.dart';

class ModeratorsListView extends StatelessWidget {
  const ModeratorsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Moderators')),
      body: ListView.builder(
        itemCount: 16,
        itemBuilder: (context, index) => MemberRow(),
      ),
    );
  }
}
