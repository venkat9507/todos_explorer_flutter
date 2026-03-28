import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/core.dart' show TodoSort;
import '../providers/todos_provider.dart' show todosNotifierProvider;

class TodosSortMenu extends ConsumerWidget {
  const TodosSortMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only rebuilds when the sort order changes!
    final currentSort = ref.watch(todosNotifierProvider.select((s) => s.sort));
    final notifier = ref.read(todosNotifierProvider.notifier);

    return PopupMenuButton<TodoSort>(
      icon: const Icon(Icons.sort),
      tooltip: 'Sort todos',
      onSelected: notifier.setSort,
      itemBuilder: (context) => [
        _sortMenuItem(TodoSort.titleAZ, 'Title A → Z', currentSort),
        _sortMenuItem(TodoSort.titleZA, 'Title Z → A', currentSort),
        _sortMenuItem(TodoSort.completedFirst, 'Completed first', currentSort),
        _sortMenuItem(TodoSort.pendingFirst, 'Pending first', currentSort),
        _sortMenuItem(TodoSort.idLowToHigh, 'ID: Low to High', currentSort),
        _sortMenuItem(TodoSort.idHighToLow, 'ID: High to Low', currentSort),
      ],
    );
  }

  PopupMenuItem<TodoSort> _sortMenuItem(
      TodoSort value, String label, TodoSort current) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          if (value == current)
            const Icon(Icons.check, size: 18)
          else
            const SizedBox(width: 18),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}
