import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/file_utils.dart';

/// Repository for file operations
class FileRepository {
  /// Reads file content from path or URI
  Future<String> readFile(String path) async {
    try {
      return await FileUtils.readFile(path);
    } catch (e) {
      throw FileReadException('Failed to read file: $e');
    }
  }

  /// Writes content to file
  Future<void> writeFile(String path, String content) async {
    try {
      await FileUtils.writeFile(path, content);
    } catch (e) {
      throw FileWriteException('Failed to write file: $e');
    }
  }

  /// Gets file name from path
  String getFileName(String path) {
    return FileUtils.getFileName(path);
  }

  /// Checks if file is markdown
  bool isMarkdownFile(String path) {
    return FileUtils.isMarkdownFile(path);
  }
}

/// File repository provider
final fileRepositoryProvider = Provider<FileRepository>((ref) {
  return FileRepository();
});

/// Custom exception for file read errors
class FileReadException implements Exception {
  final String message;
  FileReadException(this.message);
  
  @override
  String toString() => 'FileReadException: $message';
}

/// Custom exception for file write errors
class FileWriteException implements Exception {
  final String message;
  FileWriteException(this.message);
  
  @override
  String toString() => 'FileWriteException: $message';
}
