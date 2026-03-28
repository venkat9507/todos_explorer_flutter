import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_app/common/widgets/widgets.dart';
import 'package:flutter_interview_app/core/core.dart';

void main() {
  testWidgets('ErrorRetryView renders correctly and handles interactions',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    bool retryPressed = false;

    // Pump with a specific error message
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorRetryView(
            error: 'Test Error Message',
            onRetry: () => retryPressed = true,
          ),
        ),
      ),
    );

    // ── Verify all UI elements ──
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.text(AppConstants.defaultErrorTitle), findsOneWidget);
    expect(find.text('Test Error Message'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byIcon(Icons.refresh), findsOneWidget);
    expect(find.text(AppConstants.retryButtonLabel), findsOneWidget);

    // ── Verify button callback ──
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    button.onPressed!();
    expect(retryPressed, isTrue);

    // ── Verify widget works with a different error message ──
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorRetryView(
            error: 'Network timeout',
            onRetry: () {},
          ),
        ),
      ),
    );

    expect(find.text('Network timeout'), findsOneWidget);
    // Previous error message should be gone
    expect(find.text('Test Error Message'), findsNothing);
    // Title should still be present
    expect(find.text(AppConstants.defaultErrorTitle), findsOneWidget);
  });
}
