import 'package:auth/common/functions/custom_list_tile.dart';
import 'package:auth/core/styels.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroupsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GroupsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      elevation: 0.5,
      automaticallyImplyLeading: false,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Theme.of(context).iconTheme.color,
          size: 25,
        ),
      ),

      title: Text("Groups", style: Styles.textStyle18),

      actions: [
        IconButton(
          icon: Icon(
            Icons.add_box_outlined,
            color: Theme.of(context).iconTheme.color,
            size: 28,
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) {
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomListTile(
                          icon: Icons.add_to_photos_outlined,
                          text: "Add post",
                          onTap: () {
                            context.pop();
                            //TODO: add new group post
                          },
                        ),
                        CustomListTile(
                          icon: Icons.group_add_outlined,
                          text: "Create Group",
                          onTap: () {
                            context.pop();
                            //TODO: add new group
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        IconButton(
          icon: Icon(
            Icons.search,
            color: Theme.of(context).iconTheme.color,
            size: 28,
          ),
          onPressed: () {
            //TODO ADD SEARCH GROUPS
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
