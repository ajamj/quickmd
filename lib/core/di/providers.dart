import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// File path provider - holds the current file path from intent
final filePathProvider = StateProvider<String?>((ref) {
  return null;
});

/// App theme mode provider
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.system;
});

/// App loading state provider
final isLoadingProvider = StateProvider<bool>((ref) {
  return false;
});
