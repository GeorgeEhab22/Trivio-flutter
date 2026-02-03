import 'package:auth/presentation/groups/manage_group/widgets/member_row.dart';
import 'package:flutter/material.dart';

class MembersListView extends StatelessWidget {
  const MembersListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Members')),
      body: ListView.builder(
        itemCount: 16,
        itemBuilder: (context, index) => MemberRow(),
      ),
    );
  }
}
