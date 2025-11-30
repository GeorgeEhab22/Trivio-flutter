import 'package:flutter/material.dart';

class ReactionItem extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onSelected;

  const ReactionItem({
    super.key,
    required this.emoji,
    required this.label,
    required this.onSelected,
  });

  static const _labelTextStyle = TextStyle(
    color: Colors.black87,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return HoverPulseBuilder(
      onSelected: onSelected,
      builder: (context, animation) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: animation,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(label, style: _labelTextStyle),
                ),
              ),

              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                elevation: 2,
                child: Semantics(
                  label: label,
                  button: true,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


class HoverPulseBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, Animation<double> animation) builder;
  final VoidCallback onSelected;
  final Duration animationDuration;

  const HoverPulseBuilder({
    super.key,
    required this.builder,
    required this.onSelected,
    this.animationDuration = const Duration(milliseconds: 150),
  });

  @override
  State<HoverPulseBuilder> createState() => _HoverPulseBuilderState();
}

class _HoverPulseBuilderState extends State<HoverPulseBuilder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (!mounted) return;
    await _controller.forward();
    await Future.delayed(const Duration(milliseconds: 80));
    
    if (!mounted) return;
    await _controller.reverse();
    
    if (mounted) widget.onSelected();
  }

  void _handleHover(bool isHovering) {
    if (isHovering) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _handleTap,
        onTapCancel: () => _controller.reverse(),
        child: widget.builder(context, _animation),
      ),
    );
  }
}