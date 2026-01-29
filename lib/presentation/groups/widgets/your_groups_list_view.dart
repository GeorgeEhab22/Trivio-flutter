import 'package:auth/presentation/groups/widgets/your_group_item.dart';
import 'package:flutter/material.dart';

class YourGroupsListView extends StatelessWidget {
  const YourGroupsListView({super.key});

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
          return const YourGroupItem(
            title: "nameeeeeeee",
            imageUrl: "https://picsum.photos/500",
          );
        },
      ),
    );
  }
}
