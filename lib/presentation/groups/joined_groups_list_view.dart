import 'package:auth/core/styels.dart';
import 'package:auth/presentation/groups/widgets/group_item.dart';
import 'package:flutter/material.dart';

class JoinedGroupsListView extends StatelessWidget {
  const JoinedGroupsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 16,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.search,
                    color: Theme.of(context).iconTheme.color,
                    size: 23,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Search',
                      style: Styles.textStyle16.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const GroupItem(
          title: "barcelona g1",
          imageUrl: "https://picsum.photos/500",
          isHorizontal: true,
        );
      },
    );
  }
}
