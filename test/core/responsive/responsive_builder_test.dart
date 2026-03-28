import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_app/core/constants/enums.dart';
import 'package:flutter_interview_app/core/responsive/responsive_builder.dart';
import 'package:flutter_interview_app/core/responsive/responsive_config.dart';

void main() {
  group('ResponsiveBuilder', () {
    testWidgets('provides phone config when width < 600', (tester) async {
      // Default test surface is 800×600. The MaterialApp body gets ~800 width
      // minus any padding, but SizedBox(400) constrains our builder.
      late ResponsiveConfig capturedConfig;

      await tester.pumpWidget(
        MaterialApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 400,
              height: 400,
              child: ResponsiveBuilder(
                builder: (context, config) {
                  capturedConfig = config;
                  return const Placeholder();
                },
              ),
            ),
          ),
        ),
      );

      expect(capturedConfig.screenType, ScreenType.phone);
    });

    testWidgets('provides tablet config when width is 600–899',
        (tester) async {
      late ResponsiveConfig capturedConfig;

      await tester.pumpWidget(
        MaterialApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 700,
              height: 400,
              child: ResponsiveBuilder(
                builder: (context, config) {
                  capturedConfig = config;
                  return const Placeholder();
                },
              ),
            ),
          ),
        ),
      );

      expect(capturedConfig.screenType, ScreenType.tablet);
    });

    testWidgets('provides desktop config when width >= 900', (tester) async {
      // Widen the test surface so SizedBox(1000) can actually get 1000px
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      late ResponsiveConfig capturedConfig;

      await tester.pumpWidget(
        MaterialApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 1000,
              height: 400,
              child: ResponsiveBuilder(
                builder: (context, config) {
                  capturedConfig = config;
                  return const Placeholder();
                },
              ),
            ),
          ),
        ),
      );

      expect(capturedConfig.screenType, ScreenType.desktop);
    });

    testWidgets('rebuilds with new config when width changes', (tester) async {
      final configs = <ScreenType>[];

      Widget buildWithWidth(double width) {
        return MaterialApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: width,
              height: 400,
              child: ResponsiveBuilder(
                builder: (context, config) {
                  configs.add(config.screenType);
                  return const Placeholder();
                },
              ),
            ),
          ),
        );
      }

      await tester.pumpWidget(buildWithWidth(400));
      expect(configs.last, ScreenType.phone);

      await tester.pumpWidget(buildWithWidth(700));
      expect(configs.last, ScreenType.tablet);
    });
  });
}
