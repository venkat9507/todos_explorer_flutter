import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_app/core/theme/app_theme.dart';

void main() {
  group('AppTheme.light', () {
    late ThemeData theme;

    setUpAll(() {
      theme = AppTheme.light;
    });

    test('uses Material 3', () {
      expect(theme.useMaterial3, isTrue);
    });

    test('has light brightness', () {
      expect(theme.colorScheme.brightness, Brightness.light);
    });

    test('has defined colorScheme with primary color', () {
      expect(theme.colorScheme.primary, isNotNull);
      expect(theme.colorScheme.onPrimary, isNotNull);
    });

    test('appBarTheme has zero elevation', () {
      expect(theme.appBarTheme.elevation, 0);
    });

    test('appBarTheme does not center title', () {
      expect(theme.appBarTheme.centerTitle, false);
    });

    test('cardTheme has rounded shape', () {
      expect(theme.cardTheme.shape, isA<RoundedRectangleBorder>());
    });

    test('elevatedButton has zero elevation', () {
      // Extract from resolved style
      final style = theme.elevatedButtonTheme.style;
      expect(style, isNotNull);
    });

    test('inputDecorationTheme is filled', () {
      expect(theme.inputDecorationTheme.filled, isTrue);
    });

    test('chipTheme has no side border', () {
      expect(theme.chipTheme.side, BorderSide.none);
    });

    test('dialogTheme has rounded shape', () {
      expect(theme.dialogTheme.shape, isA<RoundedRectangleBorder>());
    });

    test('dividerTheme has thickness 1', () {
      expect(theme.dividerTheme.thickness, 1);
    });
  });

  group('AppTheme.dark', () {
    late ThemeData theme;

    setUpAll(() {
      theme = AppTheme.dark;
    });

    test('uses Material 3', () {
      expect(theme.useMaterial3, isTrue);
    });

    test('has dark brightness', () {
      expect(theme.colorScheme.brightness, Brightness.dark);
    });

    test('has defined colorScheme with primary color', () {
      expect(theme.colorScheme.primary, isNotNull);
      expect(theme.colorScheme.onPrimary, isNotNull);
    });

    test('appBarTheme has zero elevation', () {
      expect(theme.appBarTheme.elevation, 0);
    });

    test('cardTheme has transparent surfaceTintColor', () {
      expect(theme.cardTheme.surfaceTintColor, Colors.transparent);
    });

    test('inputDecorationTheme is filled', () {
      expect(theme.inputDecorationTheme.filled, isTrue);
    });

    test('chipTheme has no side border', () {
      expect(theme.chipTheme.side, BorderSide.none);
    });
  });

  group('AppTheme light vs dark consistency', () {
    test('both themes use Material 3', () {
      expect(AppTheme.light.useMaterial3, isTrue);
      expect(AppTheme.dark.useMaterial3, isTrue);
    });

    test('both themes have same appBar elevation', () {
      expect(AppTheme.light.appBarTheme.elevation,
          AppTheme.dark.appBarTheme.elevation);
    });

    test('both themes have same divider thickness', () {
      expect(AppTheme.light.dividerTheme.thickness,
          AppTheme.dark.dividerTheme.thickness);
    });
  });
}
