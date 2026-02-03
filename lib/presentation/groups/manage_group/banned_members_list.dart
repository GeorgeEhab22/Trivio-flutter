import 'package:auth/presentation/groups/manage_group/widgets/member_row.dart';
import 'package:flutter/material.dart';

class BannedMembersList extends StatelessWidget {
  const BannedMembersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Moderators')),
      body: ListView.builder(
        itemCount: 16,
        itemBuilder: (context, index) => MemberRow(bannedList: true,),
      ),
    );
  }
}