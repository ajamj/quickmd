import 'package:flutter_test/flutter_test.dart';
import 'package:quickmd/features/editor/search/search_service.dart';

void main() {
  group('SearchService - Phase 5 Tests', () {
    late SearchService searchService;

    setUp(() {
      searchService = SearchService();
    });

    test('should find all occurrences of search term', () {
      const text = 'Hello world. Hello again. Hello world.';
      searchService.setSourceText(text);
      
      final results = searchService.findAll('Hello');
      
      expect(results.length, 3);
      expect(results[0].start, 0);
      expect(results[1].start, 13);
      expect(results[2].start, 26);
    });

    test('should be case-insensitive by default', () {
      const text = 'Hello hello HELLO';
      searchService.setSourceText(text);
      
      final results = searchService.findAll('hello');
      
      expect(results.length, 3);
    });

    test('should replace first occurrence', () {
      const text = 'Hello world. Hello again.';
      searchService.setSourceText(text);
      
      final result = searchService.replaceFirst('Hello', 'Hi');
      
      expect(result, 'Hi world. Hello again.');
    });

    test('should replace all occurrences', () {
      const text = 'Hello world. Hello again.';
      searchService.setSourceText(text);
      
      final result = searchService.replaceAll('Hello', 'Hi');
      
      expect(result, 'Hi world. Hi again.');
    });

    test('should handle empty search term', () {
      const text = 'Hello world';
      searchService.setSourceText(text);
      
      final results = searchService.findAll('');
      
      expect(results.length, 0);
    });

    test('should handle no matches', () {
      const text = 'Hello world';
      searchService.setSourceText(text);
      
      final results = searchService.findAll('xyz');
      
      expect(results.length, 0);
    });
  });
}
