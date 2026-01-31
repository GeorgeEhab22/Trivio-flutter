import 'package:auth/presentation/groups/widgets/group_item.dart';
import 'package:flutter/material.dart';

class YourGroupsRowList extends StatelessWidget {
  const YourGroupsRowList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 12,
        separatorBuilder: (context, index) => const SizedBox(width: 0),
        itemBuilder: (context, index) {
          //TODO: replace with real group data
          return const GroupItem(
            title: "nameeeeeeee",
            imageUrl: "https://picsum.photos/500",
          );
        },
      ),
    );
  }
}
