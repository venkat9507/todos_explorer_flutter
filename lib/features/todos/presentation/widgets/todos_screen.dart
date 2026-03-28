import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/core.dart' show ResponsiveBuilder;
import '../providers/todos_provider.dart' show todosNotifierProvider;

import 'todos_list_body.dart';

abstract final class TodosScreenKeys {
  static const sortMenu = Key('sortMenu');
}

class TodosScreen extends ConsumerWidget {
  const TodosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only watch what the bottom bar needs to show
    final visibleCount = ref.watch(todosNotifierProvider.select((s) => s.visibleCount));
    final totalCount = ref.watch(todosNotifierProvider.select((s) => s.totalCount));

    return Scaffold(
      body: ResponsiveBuilder(
        builder: (context, config) {
          Widget content = TodosListBody(config: config);

          if (config.shouldCenterContent) {
            content = Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: config.maxContentWidth),
                child: content,
              ),
            );
          }

          return content;
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Showing $visibleCount of $totalCount todos',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
