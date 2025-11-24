import 'package:auth/constants/colors';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int previewLines;
  final bool canCollapse; // If true, text can collapse again when tapped

  const ExpandableText({
    super.key,
    required this.text,
    required this.previewLines,
    this.canCollapse = true, // Default: collapse allowed
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;
  bool _isOverflowing = false;
  String? _trimmedText;

  static const textStyle16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  @override
  void initState() {
    super.initState();

    //  After first layout, check if the text exceeds previewLines
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflow());
  }

  void _checkOverflow() {
    // Measure the available width
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final maxWidth = renderBox.size.width;

    // Measure text with previewLines
    final textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: textStyle16),
      maxLines: widget.previewLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    final isOverflow = textPainter.didExceedMaxLines;

    if (mounted) {
      setState(() {
        _isOverflowing = isOverflow;

        // If overflow → generate trimmed preview text
        _trimmedText = isOverflow
            ? _trimText(widget.text, widget.previewLines, maxWidth)
            : widget.text;
      });
    }
  }

  void _toggleExpand() {
    // If collapse is disabled → do not collapse again
    if (_expanded && !widget.canCollapse) return;

    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final displayText = _expanded ? widget.text : (_trimmedText ?? widget.text);

    return GestureDetector(
      onTap: _toggleExpand, // Expand or collapse text
      child: RichText(
        text: TextSpan(
          style: textStyle16.copyWith(color: AppColors.iconsColor),
          children: [
            TextSpan(text: displayText),

            // If text overflows and is not expanded → show "... more"
            if (_isOverflowing && !_expanded)
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    '... more',
                    style: textStyle16.copyWith(color: const Color(0xFF838383)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _trimText(String text, int maxLines, double maxWidth) {
    const seeMoreText = " ... more";

    int start = 0;
    int end = text.length;
    int mid;

    // Binary search to find the maximum substring that fits
    while (start < end) {
      mid = (start + end) ~/ 2;

      final painter = TextPainter(
        text: TextSpan(
          text: text.substring(0, mid) + seeMoreText,
          style: textStyle16,
        ),
        maxLines: maxLines,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: maxWidth);

      if (painter.didExceedMaxLines) {
        end = mid;
      } else {
        start = mid + 1;
      }
    }

    // Safety cut to avoid showing a broken character
    final safeEnd = (end - 4).clamp(0, text.length);
    return text.substring(0, safeEnd);
  }
}
