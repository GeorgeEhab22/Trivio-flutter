import 'package:auth/constants/colors.dart';
import 'package:flutter/material.dart';

class BaseNotificationCard extends StatelessWidget {
  final Widget leadingWidget;
  final Widget titleWidget;
  final String? subtitle;
  final String time;
  final bool isTimeHighlighted;
  final Widget? trailingWidget;
  final VoidCallback? onTap;
  final bool isRead;
  final bool isToxic;

  const BaseNotificationCard({
    super.key,
    required this.leadingWidget,
    required this.titleWidget,
    this.subtitle,
    required this.time,
    this.isTimeHighlighted = false,
    this.trailingWidget,
    this.onTap,
    this.isRead = true,
    this.isToxic = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final borderColor = isToxic
        ? Colors.redAccent.withValues(alpha: 0.5) 
        : (isDark
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.black.withValues(alpha: 0.08));

    final cardGradient = isDark
        ? const [Color(0xFF1D2228), Color(0xFF171B20)]
        : const [Color(0xFFFFFFFF), Color(0xFFF8FBF9)];

    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.38)
        : const Color(0xFF0F172A).withValues(alpha: 0.08);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: cardGradient,
            ),
            border: Border.all(color: borderColor),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  gradient: !isRead
                      ? LinearGradient(
                          colors: [
                            AppColors.primary.withValues(
                              alpha: isDark ? 0.15 : 0.08,
                            ),
                            Colors.transparent,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                      : null,
                ),
                padding: const EdgeInsets.fromLTRB(4, 16, 16, 16),
                child: Stack(
                  children: [
                    PositionedDirectional(
                      start: 0,
                      top: 0,
                      bottom: 0,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 400),
                        opacity: !isRead ? 1.0 : 0.0,
                        child: Container(
                          width: 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [AppColors.primary, AppColors.darkGreen],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 12),
                      child: Row(
                        crossAxisAlignment: subtitle == null
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                        children: [
                          leadingWidget,
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(child: titleWidget),
                                    const SizedBox(width: 8),
                                    Text(
                                      time,
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.grey[500]
                                            : Colors.grey[400],
                                        fontSize: 10,
                                        fontWeight: !isRead
                                            ? FontWeight.bold
                                            : FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                if (subtitle != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    subtitle!,
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (trailingWidget != null) ...[
                            const SizedBox(width: 12),
                            trailingWidget!,
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
