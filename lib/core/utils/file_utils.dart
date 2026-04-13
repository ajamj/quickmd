import 'dart:io';
import 'package:path/path.dart' as path;

/// Utility class for handling file operations and URI parsing
class FileUtils {
  /// Extracts file path from content:// or file:// URI
  static String? extractPathFromUri(String uri) {
    if (uri.startsWith('file://')) {
      return Uri.parse(uri).toFilePath();
    }
    
    if (uri.startsWith('content://')) {
      return uri;
    }
    
    return null;
  }

  /// Gets file extension from path
  static String getFileExtension(String filePath) {
    return path.extension(filePath).toLowerCase();
  }

  /// Checks if file is a markdown file
  static bool isMarkdownFile(String filePath) {
    final ext = getFileExtension(filePath);
    return ext == '.md' || ext == '.markdown';
  }

  /// Checks if file is a text file
  static bool isTextFile(String filePath) {
    final ext = getFileExtension(filePath);
    return ext == '.txt';
  }

  /// Gets file name from path
  static String getFileName(String filePath) {
    if (filePath.startsWith('content://')) {
      final uri = Uri.parse(filePath);
      return uri.pathSegments.last;
    }
    return path.basename(filePath);
  }

  /// Reads file content as string
  static Future<String> readFile(String filePath) async {
    if (filePath.startsWith('content://')) {
      final file = File.fromUri(Uri.parse(filePath));
      return await file.readAsString();
    }
    
    final file = File(filePath);
    return await file.readAsString();
  }

  /// Writes content to file
  static Future<void> writeFile(String filePath, String content) async {
    if (filePath.startsWith('content://')) {
      final file = File.fromUri(Uri.parse(filePath));
      await file.writeAsString(content);
    } else {
      final file = File(filePath);
      await file.writeAsString(content);
    }
  }
}
