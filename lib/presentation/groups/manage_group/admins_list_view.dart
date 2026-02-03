import 'package:auth/presentation/groups/manage_group/widgets/member_row.dart';
import 'package:flutter/material.dart';

class AdminsListView extends StatelessWidget {
  const AdminsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admins')),
      body: ListView.builder(
        itemCount: 16,
        itemBuilder: (context, index) => MemberRow(),
      ),
    );
  }
}
