import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_app/common/widgets/widgets.dart';

Widget _buildTestWidget({required String text, required String query}) {
  return MaterialApp(
    home: Center(
      child: SearchHighlightText(
        text: text,
        query: query,
        style: const TextStyle(color: Colors.black),
      ),
    ),
  );
}

/// Extracts the highlight span children from the SearchHighlightText widget.
/// Text.rich wraps our TextSpan(children: spans) inside another TextSpan for the style,
/// so the actual highlight spans are at: root → child[0] → children.
List<TextSpan> _extractHighlightSpans(WidgetTester tester) {
  final richText = tester.widget<RichText>(find.byType(RichText));
  final rootSpan = richText.text as TextSpan;
  // root has 1 child that is our TextSpan(children: spans)
  final innerSpan = rootSpan.children![0] as TextSpan;
  return innerSpan.children!.cast<TextSpan>();
}

void main() {
  testWidgets('renders plain text when query is empty', (tester) async {
    await tester.pumpWidget(_buildTestWidget(text: 'Hello World', query: ''));

    // When query is empty, SearchHighlightText returns Text(text),
    // which renders a single RichText with just text content
    expect(find.text('Hello World'), findsOneWidget);
  });

  testWidgets('highlights a single match', (tester) async {
    await tester.pumpWidget(_buildTestWidget(text: 'Hello World', query: 'World'));

    final spans = _extractHighlightSpans(tester);

    expect(spans.length, 3); // 'Hello ' + 'World' (bold) + '' (trailing)
    expect(spans[0].text, 'Hello ');
    expect(spans[1].text, 'World');
    expect(spans[1].style?.fontWeight, FontWeight.bold);
  });

  testWidgets('highlights multiple occurrences', (tester) async {
    await tester.pumpWidget(_buildTestWidget(text: 'foo bar foo', query: 'foo'));

    final spans = _extractHighlightSpans(tester);

    // 'foo' (bold) + ' bar ' + 'foo' (bold) + '' (trailing)
    final highlighted = spans.where(
      (s) => s.text == 'foo' && s.style?.fontWeight == FontWeight.bold,
    );
    expect(highlighted.length, 2);
    expect(spans.any((s) => s.text == ' bar '), isTrue);
  });

  testWidgets('highlighting is case-insensitive', (tester) async {
    await tester.pumpWidget(_buildTestWidget(text: 'Hello World', query: 'hello'));

    final spans = _extractHighlightSpans(tester);

    // Should highlight 'Hello' (preserving original case) with bold
    final helloSpan = spans.firstWhere((s) => s.text == 'Hello');
    expect(helloSpan.style?.fontWeight, FontWeight.bold);
  });
}
