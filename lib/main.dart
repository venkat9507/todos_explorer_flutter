import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/core.dart' show AppConstants, AppTheme;
import 'common/widgets/widgets.dart' show NetworkAwareWrapper;
import 'features/todos/presentation/widgets/todos_screen.dart' show TodosScreen;

/// Entry point.
///
/// [ProviderScope] is required — it is the root of the Riverpod DI tree.
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const NetworkAwareWrapper(child: TodosScreen()),
    );
  }
}
