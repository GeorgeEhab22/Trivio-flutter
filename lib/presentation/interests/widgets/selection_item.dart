import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:flutter/material.dart';

class SelectionItem extends StatefulWidget {
  final String itemName;
  final String itemLogo;
  final bool isSelected; 
  final VoidCallback onTap;

  const SelectionItem({
    super.key,
    required this.itemName,
    required this.itemLogo,
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    if (widget.isSelected) _controller.value = 1.0;
  }
@override
  void didUpdateWidget(covariant SelectionItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      widget.isSelected ? _controller.forward() : _controller.reverse();
    }
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double itemWidth = constraints.maxWidth;
        double avatarSize = itemWidth * 0.55;
        double fontSize = (itemWidth * 0.14).clamp(12.0, 19.0);
        double checkSize = itemWidth * 0.22;

        return GestureDetector(
          onTap: widget.onTap,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(itemWidth * 0.15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: avatarSize,
                      height: avatarSize,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        widget.itemLogo,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey.withValues(alpha: 0.2),
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.withValues(alpha: 0.2),
                            child: Icon(
                              Icons.person,
                              size: avatarSize * 0.5,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.itemName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: Styles.textStyle14.copyWith(
                            fontSize: fontSize,
                            height: 1.2,
                            fontWeight: widget.isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
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
                right: itemWidth * 0.15,
                child: ScaleTransition(
                  scale: _animation,
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      Icons.check,
                      size: checkSize,
                      color: AppColors.primary,
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