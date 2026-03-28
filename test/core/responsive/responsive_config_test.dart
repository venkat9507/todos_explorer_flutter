import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_app/core/constants/enums.dart';
import 'package:flutter_interview_app/core/responsive/responsive_config.dart';

void main() {
  group('ResponsiveConfig', () {
    group('fromWidth factory', () {
      test('creates phone config for narrow widths', () {
        final config = ResponsiveConfig.fromWidth(320);
        expect(config.screenType, ScreenType.phone);
      });

      test('creates tablet config for medium widths', () {
        final config = ResponsiveConfig.fromWidth(768);
        expect(config.screenType, ScreenType.tablet);
      });

      test('creates desktop config for wide widths', () {
        final config = ResponsiveConfig.fromWidth(1200);
        expect(config.screenType, ScreenType.desktop);
      });
    });

    group('phone layout', () {
      final config = ResponsiveConfig(screenType: ScreenType.phone);

      test('maxContentWidth is infinity', () {
        expect(config.maxContentWidth, double.infinity);
      });

      test('shouldCenterContent is false', () {
        expect(config.shouldCenterContent, isFalse);
      });

      test('horizontalPadding is 16', () {
        expect(config.horizontalPadding, 16);
      });

      test('verticalPadding is 8', () {
        expect(config.verticalPadding, 8);
      });

      test('chipSpacing is 8', () {
        expect(config.chipSpacing, 8);
      });

      test('cardElevation is 1', () {
        expect(config.cardElevation, 1);
      });

      test('titleFontSize is 16', () {
        expect(config.titleFontSize, 16);
      });

      test('subtitleFontSize is 12', () {
        expect(config.subtitleFontSize, 12);
      });
    });

    group('tablet layout', () {
      final config = ResponsiveConfig(screenType: ScreenType.tablet);

      test('maxContentWidth is 600', () {
        expect(config.maxContentWidth, 600);
      });

      test('shouldCenterContent is true', () {
        expect(config.shouldCenterContent, isTrue);
      });

      test('horizontalPadding is 24', () {
        expect(config.horizontalPadding, 24);
      });

      test('verticalPadding is 12', () {
        expect(config.verticalPadding, 12);
      });

      test('chipSpacing is 12', () {
        expect(config.chipSpacing, 12);
      });

      test('cardElevation is 2', () {
        expect(config.cardElevation, 2);
      });

      test('titleFontSize is 18', () {
        expect(config.titleFontSize, 18);
      });
    });

    group('desktop layout', () {
      final config = ResponsiveConfig(screenType: ScreenType.desktop);

      test('maxContentWidth is 800', () {
        expect(config.maxContentWidth, 800);
      });

      test('shouldCenterContent is true', () {
        expect(config.shouldCenterContent, isTrue);
      });
    });

    group('EdgeInsets getters', () {
      final phoneConfig = ResponsiveConfig(screenType: ScreenType.phone);
      final tabletConfig = ResponsiveConfig(screenType: ScreenType.tablet);

      test('screenPadding uses horizontal and vertical padding', () {
        expect(phoneConfig.screenPadding,
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8));
        expect(tabletConfig.screenPadding,
            const EdgeInsets.symmetric(horizontal: 24, vertical: 12));
      });

      test('cardMargin adjusts vertical for wide screens', () {
        expect(phoneConfig.cardMargin.top, 4);
        expect(tabletConfig.cardMargin.top, 6);
      });

      test('cardContentPadding adjusts for wide screens', () {
        expect(phoneConfig.cardContentPadding.left, 16);
        expect(tabletConfig.cardContentPadding.left, 20);
      });

      test('searchFieldPadding is based on padding values', () {
        expect(phoneConfig.searchFieldPadding,
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8));
      });

      test('filterChipsPadding uses 4 vertical padding', () {
        expect(phoneConfig.filterChipsPadding.top, 4);
        expect(phoneConfig.filterChipsPadding.left, 16);
      });
    });
  });
}
