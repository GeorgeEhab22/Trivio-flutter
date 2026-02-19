import 'package:auth/constants/paths.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Trivio',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontWeight: FontWeight.w800,
              fontSize: 25,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 110,
              minWidth: 80,
              maxHeight: 36,
            ),
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.search,
                    color: Theme.of(context).iconTheme.color,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  // allow text to ellipsize
                  Flexible(
                    child: Text(
                      l10n.search,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // const SizedBox(width: 8),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  context.push(AppRoutes.messages);
                },
                icon: SizedBox(
                  width: 20,
                  height: 20,
                  child: SvgPicture.asset(
                    Paths.kSendButton,
                    fit: BoxFit.contain,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).iconTheme.color ?? Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {},
                icon: FaIcon(
                  FontAwesomeIcons.bell,
                  color: Theme.of(context).iconTheme.color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  context.push(AppRoutes.settings);
                },
                icon: Icon(
                  Icons.menu,
                  color: Theme.of(context).iconTheme.color,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
