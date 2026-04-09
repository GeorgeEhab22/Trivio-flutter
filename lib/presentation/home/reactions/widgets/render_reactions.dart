import 'package:auth/constants/paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ReactionEmoji extends StatelessWidget {
  final String path;
  final double size;

  const ReactionEmoji({
    super.key,
    required this.path,
    this.size = 16,
  });

  static const _fullColorPaths = {
    Paths.ballEmoji,
  };

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) return const SizedBox.shrink();

    final isFullColor = _fullColorPaths.contains(path);

    return SvgPicture.asset(
      path,
      width: size,
      height: size,
      colorFilter: isFullColor
          ? ColorFilter.mode(
              Theme.of(context).iconTheme.color!,
              BlendMode.srcIn,
            )
          : null
    );
  }
}