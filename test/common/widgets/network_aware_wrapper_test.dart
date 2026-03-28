import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_interview_app/common/widgets/widgets.dart';
import 'package:flutter_interview_app/core/core.dart';
import 'package:flutter_interview_app/core/network/network_monitor_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_aware_wrapper_test.mocks.dart';

@GenerateMocks([NetworkMonitor])
void main() {
  testWidgets('NetworkAwareWrapper shows child when connected', (tester) async {
    final mockMonitor = MockNetworkMonitor();
    when(mockMonitor.statusStream).thenAnswer((_) => Stream.value(NetworkStatus.connected));

    final widget = ProviderScope(
      overrides: [
        networkMonitorProvider.overrideWithValue(mockMonitor),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: NetworkAwareWrapper(
            child: Text('App Content'),
          ),
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    expect(find.text('App Content'), findsOneWidget);
    expect(find.byType(NoInternetScreen), findsNothing);
  });

  testWidgets('NetworkAwareWrapper shows NoInternetScreen when disconnected', (tester) async {
    final mockMonitor = MockNetworkMonitor();
    when(mockMonitor.statusStream).thenAnswer((_) => Stream.value(NetworkStatus.disconnected));

    final widget = ProviderScope(
      overrides: [
        networkMonitorProvider.overrideWithValue(mockMonitor),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: NetworkAwareWrapper(
            child: Text('App Content'),
          ),
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    expect(find.byType(NoInternetScreen), findsOneWidget);
    expect(find.text('App Content'), findsNothing);
  });
}
