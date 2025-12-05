import 'package:auth/presentation/home/share_post/share_buttom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/post_action_item.dart';

class ShareButton extends StatelessWidget {
  final int count;
  // final VoidCallback onShare;

  const ShareButton({super.key, required this.count});

  void _openShareSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // use `ctx` inside the builder to avoid shadowing and accidental pops on the wrong Navigator
      builder: (ctx) => ShareBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PostActionItem(
      icon: const FaIcon(FontAwesomeIcons.arrowUpFromBracket, size: 22),
      count: count,
      onTap: () => _openShareSheet(context),
    );
  }
}
