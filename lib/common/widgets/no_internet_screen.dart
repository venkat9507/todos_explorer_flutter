import 'package:flutter/material.dart';

import '../../core/core.dart' show AppConstants;

/// Full-screen "No Internet" indicator with animated wifi-off icon.
class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated wifi-off icon (scale + fade in)
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: 0.5 + (value * 0.5),
                    child: child,
                  ),
                );
              },
              child: Icon(
                Icons.wifi_off_rounded,
                size: 120,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppConstants.noInternetTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              AppConstants.noInternetMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () {
                // Stream auto-reconnects — this is mostly for user comfort
              },
              icon: const Icon(Icons.refresh),
              label: const Text(AppConstants.retryButtonLabel),
            ),
          ],
        ),
      ),
    );
  }
}
