import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:flutter/material.dart';

class SelectionItem extends StatefulWidget {
  final String teamName;
  final String teamLogo;
  final bool isSelected; 
  final VoidCallback onTap;

  const SelectionItem({
    super.key,
    required this.teamName,
    required this.teamLogo,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<SelectionItem> createState() => _SelectionItemState();
}

class _SelectionItemState extends State<SelectionItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _internalSelected = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _internalSelected = widget.isSelected;
    if (_internalSelected) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _internalSelected = !_internalSelected;
      if (_internalSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 110,
            width: double.infinity,
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(widget.teamLogo),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.teamName,
                  style: Styles.textStyle14.copyWith(
                    fontWeight: _internalSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),

          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: BorderPainter(
                      progress: _animation.value,
                      color: AppColors.primary,
                    ),
                  );
                },
              ),
            ),
          ),

          Positioned(
            bottom: -3,
            right: 25,
            child: ScaleTransition(
              scale: _animation,
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(Icons.check, size: 20, color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BorderPainter extends CustomPainter {
  final double progress;
  final Color color;

  BorderPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(6, 6, size.width - 12, size.height - 12);
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(20)));

    final pathMetrics = path.computeMetrics().first;
    final extractPath = pathMetrics.extractPath(
      0,
      pathMetrics.length * progress,
    );

    canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
