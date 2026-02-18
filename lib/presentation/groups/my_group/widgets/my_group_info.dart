import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/groups/my_group/widgets/my_group_description.dart';
import 'package:auth/presentation/groups/widgets/number_of_members_row.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyGroupInfo extends StatelessWidget {
  final String groupName;
  final String groupId;
  final String? description;
  final int membersCount;

  const MyGroupInfo({
    super.key,
    required this.groupName,
    required this.groupId,
    this.description,
    required this.membersCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                groupName,
                style: Styles.textStyle25,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "•",
                style: TextStyle(fontSize: 24, color: Colors.grey),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => context.push(AppRoutes.groupMembers, extra: groupId),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: NumberOfMembersRow(numOfMembers: membersCount),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        MyGroupDescription(
          groupId: groupId,
          groupName: groupName,
          groupDescription: description,
        ),
      ],
    );
  }
}
