import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_app/common/widgets/widgets.dart';

void main() {
  testWidgets('debug button position', (tester) async {
    tester.view.physicalSize = const Size(1000, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorRetryView(
            error: 'Error',
            onRetry: () {},
          ),
        ),
      ),
    );

    final buttonFinder = find.byType(ElevatedButton);
    expect(buttonFinder, findsOneWidget);

    final box = tester.renderObject(buttonFinder) as RenderBox;
    final position = box.localToGlobal(Offset.zero);
    final size = box.size;
    debugPrint('Button position: $position, size: $size');
    debugPrint('Button center Y: ${position.dy + size.height / 2}');
    debugPrint('Screen size: ${tester.view.physicalSize}');

    // Try tapping at the button center
    final center = position + Offset(size.width / 2, size.height / 2);
    debugPrint('Tapping at: $center');
    
    await tester.tapAt(center);
    expect(true, isTrue);
  });
}
