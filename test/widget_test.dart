import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmd/main.dart';
import 'package:quickmd/core/utils/file_utils.dart';

void main() {
  group('FileUtils', () {
    test('should extract path from file:// URI', () {
      const uri = 'file:///storage/emulated/0/Documents/test.md';
      final result = FileUtils.extractPathFromUri(uri);
      // On Windows, path conversion uses backslashes
      expect(result, anyOf([
        '/storage/emulated/0/Documents/test.md',
        '\\storage\\emulated\\0\\Documents\\test.md',
      ]));
    });

    test('should return content:// URI as-is', () {
      const uri = 'content://com.android.externalfile.documents/document/1234';
      final result = FileUtils.extractPathFromUri(uri);
      expect(result, uri);
    });

    test('should return null for invalid URI', () {
      const uri = 'invalid://test.md';
      final result = FileUtils.extractPathFromUri(uri);
      expect(result, isNull);
    });

    test('should identify markdown files', () {
      expect(FileUtils.isMarkdownFile('test.md'), isTrue);
      expect(FileUtils.isMarkdownFile('test.markdown'), isTrue);
      expect(FileUtils.isMarkdownFile('test.txt'), isFalse);
    });

    test('should identify text files', () {
      expect(FileUtils.isTextFile('test.txt'), isTrue);
      expect(FileUtils.isTextFile('test.md'), isFalse);
    });

    test('should extract file name from path', () {
      expect(FileUtils.getFileName('/path/to/test.md'), 'test.md');
      expect(FileUtils.getFileName('test.txt'), 'test.txt');
    });
  });

  group('QuickMD App', () {
    testWidgets('should display app title without errors', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: QuickMDApp(),
        ),
      );

      // Verify app builds without errors
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
