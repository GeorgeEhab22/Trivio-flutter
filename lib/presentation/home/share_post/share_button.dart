import 'package:auth/presentation/home/share_post/share_buttom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/post_action_item.dart';

class ShareButton extends StatelessWidget {
  final int count;
  final bool isReelView;
  // final VoidCallback onShare;

  const ShareButton({super.key, required this.count, this.isReelView = false});

  void _openShareSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isReelView
          ? Colors.black.withValues(alpha: 0.08)
          : Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // use `ctx` inside the builder to avoid shadowing and accidental pops on the wrong Navigator
      builder: (ctx) => Theme(
        data: isReelView ? ThemeData.dark() : Theme.of(context),
        child: const ShareBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = isReelView ? Colors.white : Theme.of(context).iconTheme.color;
    final iconSize = isReelView ? 28.0 : 22.0;
    return PostActionItem(
      icon:  FaIcon(FontAwesomeIcons.arrowUpFromBracket, size: iconSize,color: iconColor,),
      count: count,
      color: iconColor,
      isVertical: isReelView,
      onTap: () => _openShareSheet(context),
    );
  }
}
