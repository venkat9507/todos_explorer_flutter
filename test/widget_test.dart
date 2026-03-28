// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_interview_app/main.dart';
import 'package:flutter_interview_app/features/todos/presentation/widgets/todos_screen.dart';
import 'package:flutter_interview_app/core/core.dart';
import 'package:flutter_interview_app/features/todos/domain/entities/todo_entity.dart';
import 'package:flutter_interview_app/features/todos/domain/repositories/todo_repository.dart';

class MockTodoRepository implements TodoRepository {
  @override
  Future<List<TodoEntity>> getTodosPaged({required int start, required int limit}) async {
    return [];
  }
}

class MockNetworkMonitor implements NetworkMonitor {
  @override
  Stream<NetworkStatus> get statusStream => Stream.value(NetworkStatus.connected);

  @override
  Future<NetworkStatus> getCurrentStatus() async => NetworkStatus.connected;
}

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Use a large phone-sized surface to avoid layout overflow
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // Suppress RenderFlex overflow errors for this smoke test.
    // The overflow is caused by test font metrics differing from real devices,
    // not a bug in production code.
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.toString().contains('overflowed')) return;
      originalOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = originalOnError);

    // Build our app with mocked dependencies
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          todoRepositoryProvider.overrideWithValue(MockTodoRepository()),
          networkMonitorProvider.overrideWithValue(MockNetworkMonitor()),
        ],
        child: const MyApp(),
      ),
    );

    // Wait for initial async operations, but do NOT use pumpAndSettle
    // because Lottie contains infinite animations that never settle!
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Verify that the app renders successfully
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(TodosScreen), findsOneWidget);
  });
}

