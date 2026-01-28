import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/groups/widgets/groups_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroupsView extends StatelessWidget {
  const GroupsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GroupsAppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Your groups", style: Styles.textStyle18,),
                CustomSquareButton(
                  label: "See all",
                  isExpanded: false,
                  textColor: Colors.blue,
                  onTap: () => context.push('/your_groups'),

                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16),
              itemCount: 12,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      //TODO Replace with group image
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey[200],
                        child: const Icon(
                          Icons.groups,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const SizedBox(
                        width: 70,
                        //TODO Replace with group name
                        child: Text(
                          "Group Nameeeeee",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
