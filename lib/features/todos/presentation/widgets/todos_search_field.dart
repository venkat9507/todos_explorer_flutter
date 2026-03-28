import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/core.dart' show ResponsiveConfig;
import '../providers/todos_provider.dart' show todosNotifierProvider;

class TodosSearchField extends ConsumerStatefulWidget {
  final ResponsiveConfig config;
  const TodosSearchField({super.key, required this.config});

  @override
  ConsumerState<TodosSearchField> createState() => _TodosSearchFieldState();
}

class _TodosSearchFieldState extends ConsumerState<TodosSearchField> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    // Maintain local state for the UI text field controller
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We only need to watch the searchQuery and searchAsFilter values
    final searchQuery =
        ref.watch(todosNotifierProvider.select((s) => s.searchQuery));
    final searchAsFilter =
        ref.watch(todosNotifierProvider.select((s) => s.searchAsFilter));
    final notifier = ref.read(todosNotifierProvider.notifier);

    return Padding(
      padding: widget.config.searchFieldPadding,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search todos...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          notifier.setSearchQuery('');
                        },
                      )
                    : null,
              ),
              onChanged: notifier.setSearchQuery,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Switch(
                value: searchAsFilter,
                onChanged: (_) => notifier.toggleSearchAsFilter(),
              ),
              Text('Filter', style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}
