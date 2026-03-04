import 'package:flutter/material.dart';

class CustomSquareButton extends StatelessWidget {
  final IconData? icon;
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
        ] 
        else if (leadingIcon != null) ...[
          Icon(
            leadingIcon,
            color: iconColor ?? Theme.of(context).iconTheme.color,
            size: 20,
          ),
          const SizedBox(width: 8),
        ],
        
        Flexible(
          child: Text(label ?? '', textAlign: TextAlign.center, style: style),
        ),
        
        if (trailingIcon != null) ...[
          const SizedBox(width: 8),
          Icon(
            trailingIcon,
            color: iconColor ?? Theme.of(context).iconTheme.color,
            size: 20,
          ),
        ],
      ],
    );
  }

  Widget buildColumnLayout(BuildContext context, TextStyle style) {
    return Column(
      crossAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            color: iconColor ?? Theme.of(context).iconTheme.color,
            size: 24,
          ),
          const SizedBox(height: 6),
        ],
        Text(label ?? '', textAlign: TextAlign.center, style: style),
      ],
    );
  }
}
