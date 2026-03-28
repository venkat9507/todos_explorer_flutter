import 'package:flutter/material.dart';

import '../constants/enums.dart' show ScreenType;

/// Every widget reads responsive values from this instead of doing its own
/// MediaQuery checks. Computed once from [ScreenType].
class ResponsiveConfig {
  final ScreenType screenType;

  const ResponsiveConfig({required this.screenType});

  factory ResponsiveConfig.fromWidth(double width) {
    return ResponsiveConfig(screenType: ScreenType.fromWidth(width));
  }

  double get maxContentWidth => switch (screenType) {
        ScreenType.phone => double.infinity,
        ScreenType.tablet => 600,
        ScreenType.desktop => 800,
      };

  bool get shouldCenterContent => screenType.isWide;

  double get horizontalPadding => switch (screenType) {
        ScreenType.phone => 16,
        ScreenType.tablet => 24,
        ScreenType.desktop => 24,
      };

  double get verticalPadding => switch (screenType) {
        ScreenType.phone => 8,
        ScreenType.tablet => 12,
        ScreenType.desktop => 12,
      };

  EdgeInsets get screenPadding => EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      );

  EdgeInsets get cardMargin => EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: screenType.isWide ? 6 : 4,
      );

  double get cardElevation => screenType.isWide ? 2 : 1;

  EdgeInsets get cardContentPadding => EdgeInsets.symmetric(
        horizontal: screenType.isWide ? 20 : 16,
        vertical: screenType.isWide ? 4 : 0,
      );

  EdgeInsets get searchFieldPadding => EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      );

  EdgeInsets get filterChipsPadding => EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 4,
      );

  double get chipSpacing => screenType.isWide ? 12 : 8;

  double get titleFontSize => screenType.isWide ? 18 : 16;
  double get subtitleFontSize => screenType.isWide ? 14 : 12;
}
