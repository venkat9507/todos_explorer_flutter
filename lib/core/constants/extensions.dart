import 'package:flutter/material.dart';

import 'enums.dart' show ScreenType;
import '../responsive/responsive_config.dart' show ResponsiveConfig;

/// Usage: `context.responsive.horizontalPadding`, `context.isWideScreen`
extension ResponsiveExtension on BuildContext {
  ResponsiveConfig get responsive {
    final width = MediaQuery.sizeOf(this).width;
    return ResponsiveConfig.fromWidth(width);
  }

  ScreenType get screenType {
    final width = MediaQuery.sizeOf(this).width;
    return ScreenType.fromWidth(width);
  }

  bool get isWideScreen => screenType.isWide;
}
