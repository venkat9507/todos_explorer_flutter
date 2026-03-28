import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_app/common/widgets/widgets.dart';
import 'package:flutter_interview_app/core/core.dart';

void main() {
  testWidgets('NoInternetScreen renders properly', (tester) async {
    const widget = MaterialApp(
      home: NoInternetScreen(),
    );

    await tester.pumpWidget(widget);
    
    // allow animation to complete
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
    expect(find.text(AppConstants.retryButtonLabel), findsOneWidget);
  });
}
