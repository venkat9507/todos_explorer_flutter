import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_app/common/widgets/widgets.dart';

Widget _buildTestWidget({required int index, required Widget child}) {
  return MaterialApp(
    home: Scaffold(
      body: SlideInCard(index: index, child: child),
    ),
  );
}

void main() {
  group('SlideInCard', () {
    testWidgets('renders the child widget', (tester) async {
      await tester.pumpWidget(
        _buildTestWidget(index: 0, child: const Text('Test Card')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Test Card'), findsOneWidget);
    });

    testWidgets('contains SlideTransition and FadeTransition', (tester) async {
      await tester.pumpWidget(
        _buildTestWidget(index: 0, child: const Text('Test Card')),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SlideTransition), findsOneWidget);
      expect(find.byType(FadeTransition), findsOneWidget);
    });

    testWidgets('starts off-screen and fades in after animation',
        (tester) async {
      await tester.pumpWidget(
        _buildTestWidget(index: 0, child: const Text('Test Card')),
      );
      // Pump once to build, but don't settle — captures initial state
      await tester.pump();

      final slideBefore =
          tester.widget<SlideTransition>(find.byType(SlideTransition));
      final fadeBefore =
          tester.widget<FadeTransition>(find.byType(FadeTransition));

      expect(slideBefore.position.value, const Offset(1, 0));
      expect(fadeBefore.opacity.value, 0.0);

      // Now settle all timers and animation
      await tester.pumpAndSettle();

      final slideAfter =
          tester.widget<SlideTransition>(find.byType(SlideTransition));
      final fadeAfter =
          tester.widget<FadeTransition>(find.byType(FadeTransition));

      expect(slideAfter.position.value, Offset.zero);
      expect(fadeAfter.opacity.value, 1.0);
    });

    testWidgets('stagger delay increases with index', (tester) async {
      // index 5 → 250ms delay before animation starts
      await tester.pumpWidget(
        _buildTestWidget(index: 5, child: const Text('Delayed Card')),
      );

      // After 100ms the 250ms delay hasn't fired, animation hasn't started
      await tester.pump(const Duration(milliseconds: 100));

      final slideBefore =
          tester.widget<SlideTransition>(find.byType(SlideTransition));
      expect(slideBefore.position.value, const Offset(1, 0));

      // Pump past the remaining delay then let the animation settle
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      final slideAfter =
          tester.widget<SlideTransition>(find.byType(SlideTransition));
      expect(slideAfter.position.value, Offset.zero);
    });

    testWidgets('stagger delay resets every 20 items via modulo',
        (tester) async {
      // index 20 → 20 % 20 = 0 → 0ms delay (same as index 0)
      await tester.pumpWidget(
        _buildTestWidget(index: 20, child: const Text('Page 2 Card')),
      );

      // Pump to fire the 0ms Future.delayed + a bit of animation
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));

      final slideTransition =
          tester.widget<SlideTransition>(find.byType(SlideTransition));
      // Animation should have started (offset no longer exactly 1,0)
      expect(slideTransition.position.value.dx, lessThan(1.0));

      await tester.pumpAndSettle();
    });

    testWidgets('is in mid-animation partway through', (tester) async {
      await tester.pumpWidget(
        _buildTestWidget(index: 0, child: const Text('Animating')),
      );

      // Fire the 0ms delayed callback then advance partway through 400ms animation
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 200));

      final slideTransition =
          tester.widget<SlideTransition>(find.byType(SlideTransition));
      final fadeTransition =
          tester.widget<FadeTransition>(find.byType(FadeTransition));

      expect(slideTransition.position.value.dx, greaterThan(0.0));
      expect(slideTransition.position.value.dx, lessThan(1.0));
      expect(fadeTransition.opacity.value, greaterThan(0.0));
      expect(fadeTransition.opacity.value, lessThan(1.0));

      await tester.pumpAndSettle();
    });

    testWidgets('multiple cards render independently', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                SlideInCard(index: 0, child: const Text('Card 0')),
                SlideInCard(index: 1, child: const Text('Card 1')),
                SlideInCard(index: 2, child: const Text('Card 2')),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(SlideInCard), findsNWidgets(3));
      expect(find.byType(SlideTransition), findsNWidgets(3));
      expect(find.byType(FadeTransition), findsNWidgets(3));

      await tester.pumpAndSettle();

      expect(find.text('Card 0'), findsOneWidget);
      expect(find.text('Card 1'), findsOneWidget);
      expect(find.text('Card 2'), findsOneWidget);
    });

    testWidgets('disposes without error', (tester) async {
      await tester.pumpWidget(
        _buildTestWidget(index: 0, child: const Text('Dispose Test')),
      );
      await tester.pumpAndSettle();

      // Replace with an empty container to trigger dispose
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SizedBox.shrink())),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SlideInCard), findsNothing);
    });
  });
}
