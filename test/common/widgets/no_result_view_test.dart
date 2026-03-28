import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_app/common/widgets/widgets.dart';
import 'package:flutter_interview_app/core/core.dart';

void main() {
  testWidgets('NoResultsView displays search icon when hasSearch is true',
      (tester) async {
    final widget = MaterialApp(
      home: Scaffold(
        body: NoResultsView(
          hasSearch: true,
          hasMore: false,
          onLoadMore: () {},
        ),
      ),
    );

    await tester.pumpWidget(widget);
    expect(find.byIcon(Icons.search_off), findsOneWidget);
    expect(find.text(AppConstants.noSearchResultsMessage), findsOneWidget);
  });

  testWidgets('NoResultsView displays inbox icon when hasSearch is false',
      (tester) async {
    final widget = MaterialApp(
      home: Scaffold(
        body: NoResultsView(
          hasSearch: false,
          hasMore: false,
          onLoadMore: () {},
        ),
      ),
    );

    await tester.pumpWidget(widget);
    expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    expect(find.text(AppConstants.emptyListMessage), findsOneWidget);
  });

  testWidgets(
      'NoResultsView displays load more message if hasSearch and hasMore are true',
      (tester) async {
    // Needs onLoadMore definition so we don't have compile errors in the widget usage
    const widget = MaterialApp(
      home: Scaffold(
        body: NoResultsView(
          hasSearch: true,
          hasMore: true,
          onLoadMore: emptyCallback,
        ),
      ),
    );

    await tester.pumpWidget(widget);
    expect(find.text(AppConstants.scrollLoadMoreMessage), findsOneWidget);
  });
}

void emptyCallback() {}
