import 'package:auth/common/functions/custom_list_tile.dart';
import 'package:auth/core/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroupPreviewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const GroupPreviewAppBar({super.key});

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
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            color: Theme.of(context).iconTheme.color,
            size: 28,
          ),
          onPressed: () {
            context.push(AppRoutes.search);
          },
        ),
        IconButton(
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
                          icon: Icons.link,
                          text: "Copy link",
                          onTap: () {
                            context.pop();
                            //TODO: copy link
                          },
                        ),
                        CustomListTile(
                          icon: Icons.report_gmailerrorred,
                          text: "Report group",
                          onTap: () {
                            context.pop();
                            //TODO: show report group button sheet
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          icon: Icon(
            Icons.more_horiz,
            color: Theme.of(context).iconTheme.color,
            size: 28,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
