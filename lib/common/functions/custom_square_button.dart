import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSquareButton extends StatelessWidget {
  final IconData? icon;
  final String? svgAsset;          // SVG for column layout icon
  final String? leadingSvgAsset;   // SVG for row layout leading icon
  final String? trailingSvgAsset;  // SVG for row layout trailing icon
  final String? label;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final CrossAxisAlignment alignment;
  final bool isExpanded;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool row;
  final double borderRadius;
  final double height;
  final bool isLoading;

  const CustomSquareButton({
    super.key,
    this.icon,
    this.svgAsset,
    this.leadingSvgAsset,
    this.trailingSvgAsset,
    this.label,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
    this.textColor,
    this.textStyle,
    this.alignment = CrossAxisAlignment.center,
    this.isExpanded = false,
    this.leadingIcon,
    this.trailingIcon,
    this.row = false,
    this.borderRadius = 12,
    this.height = 14,
    this.isLoading = false,
  });

  Widget _buildSvg(String asset, Color color, double size) {
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle finalTextStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: textColor ?? Theme.of(context).textTheme.bodyMedium?.color,
    ).merge(textStyle);

    Widget buttonContent = Material(
      color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: borderColor != null
            ? BorderSide(color: borderColor!, width: 0.5)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: isLoading ? null : onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: height, horizontal: 12),
          child: row
              ? buildRowLayout(context, finalTextStyle)
              : buildColumnLayout(context, finalTextStyle),
        ),
      ),
    );

    return isExpanded
        ? SizedBox(width: double.infinity, child: buttonContent)
        : buttonContent;
  }

  Widget buildRowLayout(BuildContext context, TextStyle style) {
    final Color resolvedIconColor =
        iconColor ?? Theme.of(context).iconTheme.color ?? Colors.black87;

    return Row(
      mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            height: 14,
            width: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                textColor ?? Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ] else if (leadingSvgAsset != null) ...[
          _buildSvg(leadingSvgAsset!, resolvedIconColor, 20),
          const SizedBox(width: 8),
        ] else if (leadingIcon != null) ...[
          Icon(leadingIcon, color: resolvedIconColor, size: 20),
          const SizedBox(width: 8),
        ],

        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label ?? '', 
              textAlign: TextAlign.center, 
              style: style,
              maxLines: 1, 
            ),
          ),
        ),

        if (trailingSvgAsset != null) ...[
          const SizedBox(width: 8),
          _buildSvg(trailingSvgAsset!, resolvedIconColor, 20),
        ] else if (trailingIcon != null) ...[
          const SizedBox(width: 8),
          Icon(trailingIcon, color: resolvedIconColor, size: 20),
        ],
      ],
    );
  }

  Widget buildColumnLayout(BuildContext context, TextStyle style) {
    final Color resolvedIconColor =
        iconColor ?? Theme.of(context).iconTheme.color ?? Colors.black87;

    return Column(
      crossAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (svgAsset != null) ...[
          _buildSvg(svgAsset!, resolvedIconColor, 24),
          const SizedBox(height: 6),
        ] else if (icon != null) ...[
          Icon(icon, color: resolvedIconColor, size: 24),
          const SizedBox(height: 6),
        ],
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label ?? '', 
            textAlign: TextAlign.center, 
            style: style,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}