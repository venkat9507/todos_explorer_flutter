import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/core.dart' show TodoFilter, ResponsiveConfig;
import '../providers/todos_provider.dart' show todosNotifierProvider;

class TodosFilterChips extends ConsumerWidget {
  final ResponsiveConfig config;
  const TodosFilterChips({super.key, required this.config});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only watch the filter state
    final currentFilter =
        ref.watch(todosNotifierProvider.select((s) => s.filter));
    final notifier = ref.read(todosNotifierProvider.notifier);

    return Padding(
      padding: config.filterChipsPadding,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: TodoFilter.values.map((filter) {
          final label = switch (filter) {
            TodoFilter.all => 'All',
            TodoFilter.completed => 'Completed',
            TodoFilter.pending => 'Pending',
            TodoFilter.favorites => 'Favorites',
          };
          final icon = switch (filter) {
            TodoFilter.all => Icons.list_alt,
            TodoFilter.completed => Icons.check_circle,
            TodoFilter.pending => Icons.pending_actions_outlined,
            TodoFilter.favorites => Icons.favorite,
          };
          return Padding(
            padding: EdgeInsets.only(right: config.chipSpacing),
            child: ChoiceChip(
              showCheckmark: false,
              avatar: Icon(icon, size: 18),
              label: Text(label),
              selected: currentFilter == filter,
              onSelected: (_) => notifier.setFilter(filter),
            ),
          );
          }).toList(),
        ),
      ),
    );
  }
}
