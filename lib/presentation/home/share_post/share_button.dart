import 'package:auth/common/functions/reels_buttons_green_effect.dart';
import 'package:auth/constants/paths.dart';
import 'package:auth/presentation/home/share_post/share_buttom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
      builder: (ctx) => Theme(
        data: isReelView ? ThemeData.dark() : Theme.of(context),
        child: const ShareBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = isReelView
        ? Colors.white
        : Theme.of(context).iconTheme.color;

    Widget iconWidget = SvgPicture.asset(
      Paths.shareIcon,
      colorFilter: ColorFilter.mode(
        Theme.of(context).iconTheme.color!,
        BlendMode.srcIn,
      ),
    );

    if (isReelView) {
      iconWidget = ReelsButtonsGreenEffect(child: iconWidget);
    }

    return PostActionItem(
      icon: iconWidget,
      count: count,
      color: iconColor,
      isVertical: isReelView,
      onTap: () => _openShareSheet(context),
    );
  }
}
