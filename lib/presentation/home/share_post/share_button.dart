import 'package:auth/common/functions/reels_buttons_green_effect.dart';
import 'package:auth/constants/paths.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/injection_container.dart' as di;
import 'package:auth/presentation/home/share_post/share_buttom_sheet.dart';
import 'package:auth/presentation/manager/post_cubit/get_post/get_post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../widgets/post_action_item.dart';

class ShareButton extends StatelessWidget {
  final int count;
  final bool isReelView;
  final Post post;

  const ShareButton({
    super.key,
    required this.count,
    required this.post,
    this.isReelView = false,
  });

  void _openShareSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Theme(
        data: isReelView ? ThemeData.dark() : Theme.of(context),
        child: BlocProvider(
          create: (context) => di.sl<GetPostCubit>(),
          child: ShareBottomSheet(post: post),
        ),
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
