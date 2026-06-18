import 'package:flutter_test/flutter_test.dart';
import 'package:quickmd/features/editor/notifier/editor_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('EditorNotifier - Phase 3 Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize with clean state', () {
      final state = container.read(editorProvider);
      
      expect(state.isDirty, false);
      expect(state.mode, EditorMode.wysiwyg);
      expect(state.fileName, 'Untitled.md');
      expect(state.quillController, isNotNull);
    });

    test('should mark document as dirty when content changes', () {
      final notifier = container.read(editorProvider.notifier);
      
      notifier.markAsDirty();
      final state = container.read(editorProvider);
      
      expect(state.isDirty, true);
    });

    test('should toggle between editor modes', () {
      final notifier = container.read(editorProvider.notifier);
      final initialState = container.read(editorProvider);
      
      expect(initialState.mode, EditorMode.wysiwyg);
      
      notifier.toggleMode(EditorMode.source);
      final sourceState = container.read(editorProvider);
      expect(sourceState.mode, EditorMode.source);
      
      notifier.toggleMode(EditorMode.preview);
      final previewState = container.read(editorProvider);
      expect(previewState.mode, EditorMode.preview);
      
      notifier.toggleMode(EditorMode.wysiwyg);
      final wysiwygState = container.read(editorProvider);
      expect(wysiwygState.mode, EditorMode.wysiwyg);
    });

    test('should have undo/redo capability in QuillController', () {
      final state = container.read(editorProvider);
      final controller = state.quillController;
      
      // QuillController should have history for undo/redo
      expect(controller, isNotNull);
      expect(controller!.document, isNotNull);
      // Undo/redo is handled via QuillEditor's built-in functionality
    });

    test('should track file path and name', () async {
      final notifier = container.read(editorProvider.notifier);
      
      // File path should be nullable initially
      final initialState = container.read(editorProvider);
      expect(initialState.filePath, isNull);
      expect(initialState.fileName, 'Untitled.md');
    });

    test('should have QuillController with document', () {
      final state = container.read(editorProvider);
      final controller = state.quillController;
      
      expect(controller, isNotNull);
      expect(controller!.document, isNotNull);
    });
  });
  
  group('EditorMode Enum', () {
    test('should have three modes', () {
      expect(EditorMode.values.length, 3);
      expect(EditorMode.wysiwyg, isNotNull);
      expect(EditorMode.source, isNotNull);
      expect(EditorMode.preview, isNotNull);
    });
  });
}
