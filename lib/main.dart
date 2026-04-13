import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'core/di/providers.dart';
import 'features/editor/editor_screen.dart';
import 'core/utils/file_utils.dart';

void main() {
  runApp(
    const ProviderScope(
      child: QuickMDApp(),
    ),
  );
}

class QuickMDApp extends ConsumerWidget {
  const QuickMDApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    
    return MaterialApp.router(
      title: 'QuickMD',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: _router,
    );
  }
}

// GoRouter configuration
final _router = GoRouter(
  initialLocation: '/editor',
  routes: [
    GoRoute(
      path: '/editor',
      builder: (context, state) {
        return const EditorScreen();
      },
    ),
  ],
);
