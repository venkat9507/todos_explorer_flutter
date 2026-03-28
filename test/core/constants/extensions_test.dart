import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_app/core/constants/enums.dart';
import 'package:flutter_interview_app/core/constants/extensions.dart';

void main() {
  group('ResponsiveExtension', () {
    testWidgets('returns phone screenType for narrow screen', (tester) async {
      late ScreenType capturedType;
      late bool capturedIsWide;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: Builder(
            builder: (context) {
              capturedType = context.screenType;
              capturedIsWide = context.isWideScreen;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedType, ScreenType.phone);
      expect(capturedIsWide, isFalse);
    });

    testWidgets('returns tablet screenType for medium screen', (tester) async {
      late ScreenType capturedType;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(700, 1024)),
          child: Builder(
            builder: (context) {
              capturedType = context.screenType;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedType, ScreenType.tablet);
    });

    testWidgets('returns desktop screenType for wide screen', (tester) async {
      late ScreenType capturedType;
      late bool capturedIsWide;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1200, 900)),
          child: Builder(
            builder: (context) {
              capturedType = context.screenType;
              capturedIsWide = context.isWideScreen;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedType, ScreenType.desktop);
      expect(capturedIsWide, isTrue);
    });

    testWidgets('responsive getter returns valid ResponsiveConfig',
        (tester) async {
      late double capturedPadding;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: Builder(
            builder: (context) {
              capturedPadding = context.responsive.horizontalPadding;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedPadding, 16); // phone horizontal padding
    });
  });
}
