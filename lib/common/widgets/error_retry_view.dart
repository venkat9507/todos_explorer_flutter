import 'package:flutter/material.dart';

import '../../core/core.dart' show AppConstants;

class ErrorRetryView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const ErrorRetryView({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 56, color: Colors.red),
            const SizedBox(height: 12),
            Text(AppConstants.defaultErrorTitle,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(error,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.refresh),
                  const SizedBox(width: 8),
                  Text(AppConstants.retryButtonLabel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
