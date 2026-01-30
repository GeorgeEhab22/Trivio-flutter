import 'package:auth/core/styels.dart';
import 'package:auth/presentation/groups/widgets/groups_tab_bar.dart';
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

      title: Text("Groups", style: Styles.textStyle20),

      actions: [
        IconButton(
          icon: Icon(
            Icons.add_box_outlined,
            color: Theme.of(context).iconTheme.color,
            size: 28,
          ),
          onPressed: () {
            context.push('/create_group');
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
      bottom: GroupsTabBar(),
    );
  }


  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight+40 );
}
