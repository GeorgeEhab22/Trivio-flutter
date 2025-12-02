import 'package:auth/constants/colors';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int previewLines;
  final bool canCollapse;

  const ExpandableText({
    super.key,
    required this.text,
    this.previewLines = 3,
    this.canCollapse = true,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  // Cache inputs used for overflow calculation to avoid redundant TextPainter work.
  String? _lastText;
  double? _lastMaxWidth;
  bool? _lastDidOverflow;

  static const TextStyle _textStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.iconsColor,
  );

  bool _didOverflow(String text, double maxWidth) {
    // Return cached result when inputs unchanged
    if (_lastText == text && _lastMaxWidth == maxWidth && _lastDidOverflow != null) {
      return _lastDidOverflow!;
    }

    final tp = TextPainter(
      text: TextSpan(text: text, style: _textStyle),
      maxLines: widget.previewLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    final overflow = tp.didExceedMaxLines;
    // add dispose
    tp.dispose();
    // Update cache
    _lastText = text;
    _lastMaxWidth = maxWidth;
    _lastDidOverflow = overflow;

    return overflow;
  }

  void _toggleExpand() {
    if (_expanded && !widget.canCollapse) {
      return; // don't allow collapsing
    }
    setState(() => _expanded = !_expanded);
  }

  @override
  void didUpdateWidget(covariant ExpandableText oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If text or previewLines changed, invalidate cache
    if (oldWidget.text != widget.text || oldWidget.previewLines != widget.previewLines) {
      _lastText = null;
      _lastMaxWidth = null;
      _lastDidOverflow = null;
      // If the text changed while expanded and canCollapse is false, keep expanded (or you might want to collapse)
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder to get the available width reliably
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth.isFinite ? constraints.maxWidth : MediaQuery.of(context).size.width;

      final overflow = _didOverflow(widget.text, maxWidth);

      // When expanded: show full text
      if (_expanded) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.text, style: _textStyle),
            if (widget.canCollapse)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: _toggleExpand,
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0)),
                  child: const Text('less', style: TextStyle(color: Color(0xFF838383))),
                ),
              ),
          ],
        );
      }

      // Collapsed: show truncated text with ellipsis and a "more" button if overflow detected
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.text,
            style: _textStyle,
            maxLines: widget.previewLines,
            overflow: TextOverflow.ellipsis,
          ),
          if (overflow)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: _toggleExpand,
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0)),
                child: const Text('more', style: TextStyle(color: Color(0xFF838383))),
              ),
            ),
        ],
      );
    });
  }
}
