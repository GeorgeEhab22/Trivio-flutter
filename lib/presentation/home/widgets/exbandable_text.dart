import 'package:flutter/material.dart';
import 'package:auth/l10n/app_localizations.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int previewLines;
  final bool canCollapse;
  final TextStyle? textStyle;

  const ExpandableText({
    super.key,
    required this.text,
    this.previewLines = 3,
    this.canCollapse = true,
    this.textStyle,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  String? _lastText;
  double? _lastMaxWidth;
  bool? _lastDidOverflow;

  TextStyle _getEffectiveTextStyle(BuildContext context) {
    final themeTextStyle = Theme.of(context).textTheme.bodyMedium;

    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: themeTextStyle?.color,
    ).merge(widget.textStyle);
  }

  bool _didOverflow(String text, double maxWidth, TextStyle style, BuildContext context) {
    if (_lastText == text &&
        _lastMaxWidth == maxWidth &&
        _lastDidOverflow != null) {
      return _lastDidOverflow!;
    }

    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: widget.previewLines,
      // Detect the actual app direction for accurate overflow calculation
      textDirection: Directionality.of(context),
    )..layout(maxWidth: maxWidth);

    final overflow = tp.didExceedMaxLines;
    tp.dispose();

    _lastText = text;
    _lastMaxWidth = maxWidth;
    _lastDidOverflow = overflow;
    return overflow;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = _getEffectiveTextStyle(context);
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;

        final overflow = _didOverflow(widget.text, maxWidth, effectiveStyle, context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: effectiveStyle,
              maxLines: _expanded ? null : widget.previewLines,
              overflow: _expanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
            ),
            if (overflow)
              GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    _expanded 
                        ? (widget.canCollapse ? l10n.showLess : '') 
                        : l10n.showMore,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}