import 'package:flutter/material.dart';

import 'responsive_config.dart' show ResponsiveConfig;

/// Rebuilds when available width changes (e.g., screen rotation, window resize).
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ResponsiveConfig config) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final config = ResponsiveConfig.fromWidth(constraints.maxWidth);
        return builder(context, config);
      },
    );
  }
}
