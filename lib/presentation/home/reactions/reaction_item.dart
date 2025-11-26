import 'package:flutter/material.dart';

class ReactionItem extends StatefulWidget {
  final String emoji;
  final String label;
  final VoidCallback onSelected;

  const ReactionItem({
    super.key,
    required this.emoji,
    required this.label,
    required this.onSelected,
  });

  @override
  State<ReactionItem> createState() => _ReactionItemState();
}
// TODO: Consider moving animation logic to a reusable widget if used elsewhere
class _ReactionItemState extends State<ReactionItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  static const _animDuration = Duration(milliseconds: 150);
  static const _labelTextStyle = TextStyle(
    color: Colors.black87,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _animDuration,
    );
    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Called on hover enter/exit
  void _onHover(bool hovering) {
    if (!mounted) return;
    if (hovering) {
      _safeForward();
    } else {
      _safeReverse();
    }
  }

  // Called on tap (mobile). Play a quick pulse then call the callback.
  Future<void> _onTap() async {
    if (!mounted) return;
    // quick forward
    await _safeForward();
    // short pause so the user sees the label
    await Future.delayed(const Duration(milliseconds: 80));
    // then reverse
    await _safeReverse();
    if (!mounted) return;
    widget.onSelected();
  }

  // Safe wrappers to avoid calling animation methods after dispose
  Future<void> _safeForward() async {
    try {
      if (!_controller.isAnimating && _controller.value < 1.0) {
        await _controller.forward();
      } else if (_controller.value < 1.0) {
        await _controller.forward();
      }
    } catch (_) {
      // ignore if disposed
    }
  }

  Future<void> _safeReverse() async {
    try {
      if (!_controller.isAnimating && _controller.value > 0.0) {
        await _controller.reverse();
      } else if (_controller.value > 0.0) {
        await _controller.reverse();
      }
    } catch (_) {
      // ignore if disposed
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTap,
        onTapCancel: () => _safeReverse(),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated label (appears on hover / tap)
              ScaleTransition(
                scale: _scale,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(widget.label, style: _labelTextStyle),
                ),
              ),

              // Emoji button area: use Material for proper semantics
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                elevation: 2,
                child: Semantics(
                  // announce the label/emoji to accessibility services
                  label: widget.label,
                  button: true,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(widget.emoji, style: const TextStyle(fontSize: 26)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
