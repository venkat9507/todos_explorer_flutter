import 'package:flutter/material.dart';

/// Wraps matched query substrings with a colored highlight.
class SearchHighlightText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle style;
  final int maxLines;

  const SearchHighlightText({
    super.key,
    required this.text,
    required this.query,
    required this.style,
    this.maxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(text,
          style: style, maxLines: maxLines, overflow: TextOverflow.ellipsis);
    }

    final lower = text.toLowerCase();
    final lowerQ = query.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;

    while (true) {
      final index = lower.indexOf(lowerQ, start);
      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: TextStyle(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ));
      start = index + query.length;
    }

    return Text.rich(
      TextSpan(children: spans),
      style: style,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
