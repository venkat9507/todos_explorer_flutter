import 'package:flutter/material.dart';

class EmptyStateView extends StatelessWidget {
  final bool hasSearch;
  final bool hasMore;
  final VoidCallback onLoadMore;

  const EmptyStateView({
    super.key,
    required this.hasSearch,
    required this.hasMore,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasSearch ? Icons.search_off : Icons.inbox_outlined,
            size: 56,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(80),
          ),
          const SizedBox(height: 12),
          Text(hasSearch
              ? 'No results match your search.'
              : 'Nothing here yet.'),
          if (hasSearch && hasMore) ...[
            const SizedBox(height: 8),
            const Text(
              'Scroll to load more items and retry.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }
}
