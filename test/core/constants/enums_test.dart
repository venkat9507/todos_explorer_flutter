import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_app/core/constants/enums.dart';

void main() {
  group('NetworkStatus', () {
    test('has connected and disconnected values', () {
      expect(NetworkStatus.values, containsAll([
        NetworkStatus.connected,
        NetworkStatus.disconnected,
      ]));
      expect(NetworkStatus.values.length, 2);
    });
  });

  group('TodoFilter', () {
    test('has all, completed, and pending values', () {
      expect(TodoFilter.values, containsAll([
        TodoFilter.all,
        TodoFilter.completed,
        TodoFilter.pending,
        TodoFilter.favorites,
      ]));
      expect(TodoFilter.values.length, 4);
    });
  });

  group('TodoSort', () {
    test('has all six sort options', () {
      expect(TodoSort.values, containsAll([
        TodoSort.titleAZ,
        TodoSort.titleZA,
        TodoSort.completedFirst,
        TodoSort.pendingFirst,
        TodoSort.idLowToHigh,
        TodoSort.idHighToLow,
      ]));
      expect(TodoSort.values.length, 6);
    });
  });

  group('ScreenType', () {
    group('fromWidth', () {
      test('returns phone for width < 600', () {
        expect(ScreenType.fromWidth(0), ScreenType.phone);
        expect(ScreenType.fromWidth(320), ScreenType.phone);
        expect(ScreenType.fromWidth(599), ScreenType.phone);
      });

      test('returns tablet for width 600–899', () {
        expect(ScreenType.fromWidth(600), ScreenType.tablet);
        expect(ScreenType.fromWidth(768), ScreenType.tablet);
        expect(ScreenType.fromWidth(899), ScreenType.tablet);
      });

      test('returns desktop for width >= 900', () {
        expect(ScreenType.fromWidth(900), ScreenType.desktop);
        expect(ScreenType.fromWidth(1200), ScreenType.desktop);
        expect(ScreenType.fromWidth(1920), ScreenType.desktop);
      });
    });

    group('boolean getters', () {
      test('isPhone is true only for phone', () {
        expect(ScreenType.phone.isPhone, isTrue);
        expect(ScreenType.tablet.isPhone, isFalse);
        expect(ScreenType.desktop.isPhone, isFalse);
      });

      test('isTablet is true only for tablet', () {
        expect(ScreenType.phone.isTablet, isFalse);
        expect(ScreenType.tablet.isTablet, isTrue);
        expect(ScreenType.desktop.isTablet, isFalse);
      });

      test('isDesktop is true only for desktop', () {
        expect(ScreenType.phone.isDesktop, isFalse);
        expect(ScreenType.tablet.isDesktop, isFalse);
        expect(ScreenType.desktop.isDesktop, isTrue);
      });

      test('isWide is true for tablet and desktop, false for phone', () {
        expect(ScreenType.phone.isWide, isFalse);
        expect(ScreenType.tablet.isWide, isTrue);
        expect(ScreenType.desktop.isWide, isTrue);
      });
    });
  });
}
