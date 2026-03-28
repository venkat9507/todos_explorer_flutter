import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/core.dart' show NetworkStatus, networkStatusProvider;
import 'no_internet_screen.dart' show NoInternetScreen;

/// Root wrapper — swaps between app content and NoInternetScreen
/// based on real-time network status.
class NetworkAwareWrapper extends ConsumerWidget {
  final Widget child;

  const NetworkAwareWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkStatus = ref.watch(networkStatusProvider);

    return networkStatus.when(
      data: (status) {
        if (status == NetworkStatus.disconnected) {
          return const NoInternetScreen();
        }
        return child;
      },
      loading: () => child, // assume connected while checking
      error: (_, __) => child, // assume connected on error
    );
  }
}
