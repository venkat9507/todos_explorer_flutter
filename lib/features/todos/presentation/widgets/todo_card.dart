import 'package:flutter/material.dart';
import '../../../../common/widgets/widgets.dart' show SearchHighlightText;
import '../../../../core/core.dart' show ResponsiveConfig;
import '../../domain/entities/todo_entity.dart' show TodoEntity;

class TodoCard extends StatelessWidget {
  final TodoEntity todo;
  final String searchQuery;
  final ResponsiveConfig config;
  final VoidCallback? onToggleFavorite;

  const TodoCard({
    super.key,
    required this.todo,
    required this.searchQuery,
    required this.config,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Case-insensitive substring match
    final isMatch = searchQuery.isNotEmpty &&
        todo.title.toLowerCase().contains(searchQuery.toLowerCase());

    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: config.titleFontSize,
      color: isMatch ? Colors.black : null,
    );
    final subtitleStyle = theme.textTheme.bodySmall?.copyWith(
      fontSize: config.subtitleFontSize,
      color: isMatch ? Colors.black : null,
    );

    return Card(
      color: isMatch ? const Color(0xFFFFF9C4) : null,
      margin: config.cardMargin,
      elevation: config.cardElevation,
      child: ListTile(
        contentPadding: config.cardContentPadding,
        // Leading: status icon
        leading: Icon(
          todo.completed ? Icons.check_circle : Icons.circle_outlined,
          color: todo.completed ? Colors.green : Colors.grey,
        ),
        // Title: with text highlighting for matching substring
        title: searchQuery.isNotEmpty
            ? SearchHighlightText(
                text: todo.title,
                query: searchQuery,
                style: titleStyle!,
              )
            : Text(
                todo.title,
                style: titleStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
        // Subtitle: ID and User
        subtitle: Text(
          'ID: ${todo.id} • User: ${todo.userId}',
          style: subtitleStyle,
        ),
        // Trailing: favorite button + status text
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                todo.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: todo.isFavorite ? Colors.red : Colors.grey,
                size: 20,
              ),
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.only(right: 8),
              onPressed: onToggleFavorite,
              tooltip: todo.isFavorite
                  ? 'Remove from favorites'
                  : 'Add to favorites',
            ),
            SizedBox(
              width: 72,
              child: Text(
                todo.completed ? 'Completed' : 'Pending',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: todo.completed ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
