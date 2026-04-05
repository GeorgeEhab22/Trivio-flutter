import 'package:flutter/material.dart';

final RegExp _hashtagRegex = RegExp(r"(#\S+)");

TextSpan buildHashtagSpan(String text, TextStyle? defaultStyle) {
  List<TextSpan> children = [];

  text.splitMapJoin(
    _hashtagRegex,
    onMatch: (Match match) {
      children.add(
        TextSpan(
          text: match[0],
          style: defaultStyle?.copyWith(
            color: Colors.lightGreen,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
      return match[0]!;
    },
    onNonMatch: (String nonMatch) {
      children.add(TextSpan(text: nonMatch, style: defaultStyle));
      return nonMatch;
    },
  );

  return TextSpan(style: defaultStyle, children: children);
}

class HashtagTextController extends TextEditingController {
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    return buildHashtagSpan(text, style);
  }
}
