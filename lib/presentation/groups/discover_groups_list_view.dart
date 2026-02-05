import 'package:auth/core/app_routes.dart';
import 'package:auth/presentation/groups/widgets/suggest_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DiscoverGroupsListView extends StatelessWidget {
  const DiscoverGroupsListView({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double availableWidth = (screenWidth - 42) / 2;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                "Suggested for you",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: availableWidth / 320,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              return SuggestCard(
                imageUrl: "https://picsum.photos/500",
                groupName: "messi",
                description: "descripe the group",
                isRow: false,
                onTap: () {
                  context.push(AppRoutes.groupPreview);
                },
              );
            }, childCount: 10),
          ),
        ],
      ),
    );
  }
}
