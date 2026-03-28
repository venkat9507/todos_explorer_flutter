import 'package:flutter/material.dart';

import '../../core/core.dart' show AppConstants;

class NoResultsView extends StatelessWidget {
  final bool hasSearch;
  final bool hasMore;
  final VoidCallback onLoadMore;

  const NoResultsView({
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
              ? AppConstants.noSearchResultsMessage
              : AppConstants.emptyListMessage),
          if (hasSearch && hasMore) ...[
            const SizedBox(height: 8),
            const Text(
              AppConstants.scrollLoadMoreMessage,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }
}
