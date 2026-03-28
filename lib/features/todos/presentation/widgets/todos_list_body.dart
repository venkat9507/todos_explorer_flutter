import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../../../common/widgets/widgets.dart'
    show ErrorRetryView, NoResultsView, SlideInCard;
import '../../../../core/core.dart' show TodoFilter, ResponsiveConfig;
import '../providers/todos_provider.dart' show todosNotifierProvider;
import 'todo_card.dart';
import 'todos_filter_chips.dart';
import 'todos_search_field.dart';
import 'todos_sort_menu.dart';

class TodosListBody extends ConsumerStatefulWidget {
  final ResponsiveConfig config;

  const TodosListBody({
    super.key,
    required this.config,
  });

  @override
  ConsumerState<TodosListBody> createState() => _TodosListBodyState();
}

class _TodosListBodyState extends ConsumerState<TodosListBody> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      ref.read(todosNotifierProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(todosNotifierProvider);
    final notifier = ref.read(todosNotifierProvider.notifier);
    final todos = state.filteredAndSortedTodos;

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200, // Set the height of the header
            pinned: true, // Keep the app bar minimal pinned at top
            actions: const [TodosSortMenu()],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Lottie.asset(
                    'assets/lottie.json',
                    fit: BoxFit.contain,
                  ),
                  Container(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.black.withValues(alpha: 0.2),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 16),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 1.0, end: 0.0),
                        duration: const Duration(milliseconds: 500),
                        builder: (BuildContext context, double value,
                            Widget? child) {
                          return Transform.scale(
                            scale: 1 + value,
                            child: Opacity(
                              opacity: 1 - value,
                              child: Text(
                                'Todos Explorer',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      // color: Colors.white,
                                    ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sticky Pinned Header for Search & Filters
          SliverAppBar(
            pinned: true,
            floating: false,
            automaticallyImplyLeading: false,
            toolbarHeight: 120, // Approx height for Search Field + Chips
            backgroundColor: Theme.of(context).colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation:
                4.0, // Gives a nice subtle shadow when the list scrolls beneath it!
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TodosSearchField(config: widget.config),
                TodosFilterChips(config: widget.config),
              ],
            ),
          ),

          if (state.isLoading && state.todos.isEmpty)
            const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator())),

          if (state.error != null && state.todos.isEmpty)
            SliverFillRemaining(
              child: ErrorRetryView(
                error: state.error!,
                onRetry: notifier.refresh,
              ),
            ),

          if (!state.isLoading && state.error == null && todos.isEmpty)
            SliverFillRemaining(
              child: NoResultsView(
                hasSearch: state.searchQuery.isNotEmpty ||
                    state.filter != TodoFilter.all,
                hasMore: state.hasMore,
                onLoadMore: notifier.loadMore,
              ),
            ),

          if (todos.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index == todos.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return SlideInCard(
                    index: index,
                    child: TodoCard(
                      todo: todos[index],
                      searchQuery: state.searchQuery,
                      config: widget.config,
                      onToggleFavorite: () =>
                          notifier.toggleFavorite(todos[index].id),
                    ),
                  );
                },
                childCount: todos.length + (state.isLoadingMore ? 1 : 0),
              ),
            ),
        ],
      ),
    );
  }
}
