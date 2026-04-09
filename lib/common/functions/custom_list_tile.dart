import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomListTile extends StatelessWidget {
  final IconData? icon;
  final String? svgAsset;
  final String text;
  final Color? color;
  final VoidCallback onTap;
  final bool withArrow;
  final bool redColor;

  const CustomListTile({
    super.key,
    this.icon,
    this.svgAsset,
    required this.text,
    required this.onTap,
    this.color,
    this.withArrow = false,
    this.redColor = false,
  }) : assert(
         icon != null || svgAsset != null,
         'Either icon or svgAsset must be provided',
       );

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        color ??
        (redColor
            ? Colors.redAccent
            : (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black87));

    final Color iconColor =
        color ??
        (redColor
            ? Colors.redAccent
            : (Theme.of(context).iconTheme.color ?? Colors.black87));

    Widget leadingWidget;

    if (svgAsset != null) {
      leadingWidget = SvgPicture.asset(
        svgAsset!,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      );
    } else {
      leadingWidget = Icon(icon!, color: iconColor, size: 24);
    }

    return ListTile(
      leading: leadingWidget,
      title: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: withArrow
          ? const Icon(Icons.arrow_forward_ios, size: 16)
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
    );
  }
}