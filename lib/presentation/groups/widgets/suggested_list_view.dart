import 'package:auth/presentation/groups/widgets/suggest_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SuggestedGroupsListView extends StatelessWidget {
  const SuggestedGroupsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: 5,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          //TODO: replace with real group data
          return SuggestCard(
            groupName: "Group1 suggestion",
            description: "group description",
            imageUrl: "https://picsum.photos/500",
            onTap: () {
              context.push('/get_group_by_id');
            },
          );
        },
      ),
    );
  }
}
