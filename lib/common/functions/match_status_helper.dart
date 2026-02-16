// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';

/// ULTRA BULLETPROOF Premium match status badge
/// Uses SafeAnimationMixin to prevent ALL assertion errors
class PremiumMatchStatusBadge extends StatefulWidget {
  final String status;
  final bool animate;
  final bool compact;

  const PremiumMatchStatusBadge({
    super.key,
    required this.status,
    this.animate = true,
    this.compact = false,
  });

  @override
  State<PremiumMatchStatusBadge> createState() => _PremiumMatchStatusBadgeState();
}

class _PremiumMatchStatusBadgeState extends State<PremiumMatchStatusBadge>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    // Only create controller if we need animation
    final shouldAnimate = widget.animate && 
        (widget.status == 'IN_PLAY' || widget.status == 'PAUSED');

    if (shouldAnimate) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1500),
      );

      _animation = Tween<double>(begin: 1.0, end: 1.03).animate(
        CurvedAnimation(parent: _controller!, curve: Curves.easeInOut),
      );

      _controller!.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PremiumMatchStatusBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    final oldShouldAnimate = oldWidget.animate && 
        (oldWidget.status == 'IN_PLAY' || oldWidget.status == 'PAUSED');
    final newShouldAnimate = widget.animate && 
        (widget.status == 'IN_PLAY' || widget.status == 'PAUSED');

    if (oldShouldAnimate != newShouldAnimate) {
      // Clean up old controller
      _controller?.stop();
      _controller?.dispose();
      _controller = null;
      _animation = null;

      // Setup new if needed
      if (newShouldAnimate) {
        _setupAnimation();
      }
    }
  }

  @override
  void dispose() {
    _controller?.stop();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final statusInfo = _getStatusInfo(widget.status, isDarkMode);

    final badge = Container(
      constraints: BoxConstraints(
        maxWidth: widget.compact ? 65 : 75,
        minHeight: 24,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: widget.compact ? 6 : 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 1.5, color: statusInfo.borderColor),
        boxShadow: [
          BoxShadow(
            color: statusInfo.shadowColor,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
          if (statusInfo.hasGlow)
            BoxShadow(
              color: statusInfo.glowColor,
              blurRadius: 10,
              spreadRadius: 1,
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              gradient: statusInfo.gradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (statusInfo.showDot && !widget.compact)
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: statusInfo.dotColor,
                      boxShadow: [
                        BoxShadow(
                          color: statusInfo.dotColor.withOpacity(0.5),
                          blurRadius: 2,
                          spreadRadius: 0.5,
                        ),
                      ],
                    ),
                  ),
                Text(
                  statusInfo.text,
                  style: TextStyle(
                    fontSize: widget.compact ? 10 : 11,
                    fontWeight: FontWeight.bold,
                    color: statusInfo.textColor,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Only animate if controller exists
    if (_controller != null && _animation != null) {
      return AnimatedBuilder(
        animation: _animation!,
        builder: (context, child) => Transform.scale(
          scale: _animation!.value,
          child: child,
        ),
        child: badge,
      );
    }

    return badge;
  }

  _StatusInfo _getStatusInfo(String status, bool isDarkMode) {
    switch (status) {
      case 'IN_PLAY':
        return _StatusInfo(
          text: 'LIVE',
          gradient: LinearGradient(
            colors: isDarkMode
                ? [
                    const Color(0xFF00C853).withOpacity(0.3),
                    const Color(0xFF00E676).withOpacity(0.2),
                  ]
                : [
                    const Color(0xFF00C853).withOpacity(0.25),
                    const Color(0xFF69F0AE).withOpacity(0.15),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderColor: const Color(0xFF00E676),
          textColor: isDarkMode ? const Color(0xFF00E676) : const Color(0xFF00C853),
          shadowColor: const Color(0xFF00C853).withOpacity(0.3),
          glowColor: const Color(0xFF00E676).withOpacity(0.25),
          dotColor: const Color(0xFF00E676),
          hasGlow: true,
          showDot: true,
        );

      case 'PAUSED':
        return _StatusInfo(
          text: 'HT',
          gradient: LinearGradient(
            colors: isDarkMode
                ? [
                    const Color(0xFFFFA726).withOpacity(0.3),
                    const Color(0xFFFFB74D).withOpacity(0.2),
                  ]
                : [
                    const Color(0xFFFFA726).withOpacity(0.25),
                    const Color(0xFFFFD54F).withOpacity(0.15),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderColor: const Color(0xFFFFB74D),
          textColor: isDarkMode ? const Color(0xFFFFD54F) : const Color(0xFFF57C00),
          shadowColor: const Color(0xFFFFA726).withOpacity(0.25),
          glowColor: const Color(0xFFFFB74D).withOpacity(0.2),
          dotColor: const Color(0xFFFFB74D),
          hasGlow: true,
          showDot: true,
        );

      case 'FINISHED':
        return _StatusInfo(
          text: 'FT',
          gradient: LinearGradient(
            colors: isDarkMode
                ? [
                    Colors.grey[800]!.withOpacity(0.4),
                    Colors.grey[700]!.withOpacity(0.3),
                  ]
                : [
                    Colors.grey[400]!.withOpacity(0.3),
                    Colors.grey[300]!.withOpacity(0.2),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderColor: isDarkMode ? Colors.grey[600]! : Colors.grey[500]!,
          textColor: isDarkMode ? Colors.grey[400]! : Colors.grey[700]!,
          shadowColor: Colors.grey.withOpacity(0.15),
          glowColor: Colors.transparent,
          dotColor: Colors.grey[500]!,
          hasGlow: false,
          showDot: false,
        );

      case 'TIMED':
      case 'SCHEDULED':
        return _StatusInfo(
          text: 'SOON',
          gradient: LinearGradient(
            colors: isDarkMode
                ? [
                    const Color(0xFF2196F3).withOpacity(0.3),
                    const Color(0xFF42A5F5).withOpacity(0.2),
                  ]
                : [
                    const Color(0xFF2196F3).withOpacity(0.25),
                    const Color(0xFF64B5F6).withOpacity(0.15),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderColor: const Color(0xFF42A5F5),
          textColor: isDarkMode ? const Color(0xFF64B5F6) : const Color(0xFF1976D2),
          shadowColor: const Color(0xFF2196F3).withOpacity(0.2),
          glowColor: const Color(0xFF42A5F5).withOpacity(0.1),
          dotColor: const Color(0xFF42A5F5),
          hasGlow: false,
          showDot: false,
        );

      default:
        return _StatusInfo(
          text: status.length > 4 ? status.substring(0, 4) : status,
          gradient: LinearGradient(
            colors: isDarkMode
                ? [
                    Colors.grey[800]!.withOpacity(0.3),
                    Colors.grey[700]!.withOpacity(0.2),
                  ]
                : [
                    Colors.grey[400]!.withOpacity(0.25),
                    Colors.grey[300]!.withOpacity(0.15),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderColor: Colors.grey[500]!,
          textColor: isDarkMode ? Colors.grey[400]! : Colors.grey[700]!,
          shadowColor: Colors.grey.withOpacity(0.15),
          glowColor: Colors.transparent,
          dotColor: Colors.grey[500]!,
          hasGlow: false,
          showDot: false,
        );
    }
  }
}

class _StatusInfo {
  final String text;
  final Gradient gradient;
  final Color borderColor;
  final Color textColor;
  final Color shadowColor;
  final Color glowColor;
  final Color dotColor;
  final bool hasGlow;
  final bool showDot;

  _StatusInfo({
    required this.text,
    required this.gradient,
    required this.borderColor,
    required this.textColor,
    required this.shadowColor,
    required this.glowColor,
    required this.dotColor,
    required this.hasGlow,
    required this.showDot,
  });
}