import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dart_quill_delta/dart_quill_delta.dart';
import '../../../core/di/providers.dart';
import '../../../data/repositories/file_repository.dart';

/// Editor mode enum
enum EditorMode {
  wysiwyg,    // WYSIWYG mode with Quill editor
  source,     // Source code mode with raw markdown
  preview,    // Preview mode with rendered markdown
}

/// Editor state
class EditorState {
  final String? filePath;
  final String fileName;
  final bool isDirty;
  final EditorMode mode;
  final QuillController? quillController;
  final TextEditingController? sourceController;
  final String markdownContent;

  EditorState({
    this.filePath,
    this.fileName = 'Untitled.md',
    this.isDirty = false,
    this.mode = EditorMode.wysiwyg,
    this.quillController,
    this.sourceController,
    this.markdownContent = '',
  });

  EditorState copyWith({
    String? filePath,
    String? fileName,
    bool? isDirty,
    EditorMode? mode,
    QuillController? quillController,
    TextEditingController? sourceController,
    String? markdownContent,
  }) {
    return EditorState(
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      isDirty: isDirty ?? this.isDirty,
      mode: mode ?? this.mode,
      quillController: quillController ?? this.quillController,
      sourceController: sourceController ?? this.sourceController,
      markdownContent: markdownContent ?? this.markdownContent,
    );
  }
}

/// Editor notifier provider
final editorProvider = NotifierProvider<EditorNotifier, EditorState>(() {
  return EditorNotifier();
});

class EditorNotifier extends Notifier<EditorState> {
  Timer? _autoSaveTimer;

  @override
  EditorState build() {
    // Register cleanup
    ref.onDispose(() {
      _autoSaveTimer?.cancel();
      state.quillController?.dispose();
      state.sourceController?.dispose();
    });
    
    return EditorState(
      quillController: QuillController.basic(),
      sourceController: TextEditingController(),
    );
  }

  /// Load file content
  Future<void> loadFile(String path) async {
    final ref = this.ref;
    final repository = ref.read(fileRepositoryProvider);
    
    try {
      final content = await repository.readFile(path);
      final fileName = repository.getFileName(path);

      // Convert markdown to Delta for Quill editor
      final delta = _markdownToDelta(content);

      final quillController = QuillController(
        document: Document.fromDelta(delta),
        selection: const TextSelection.collapsed(offset: 0),
      );

      final sourceController = TextEditingController(text: content);

      state = state.copyWith(
        filePath: path,
        fileName: fileName,
        quillController: quillController,
        sourceController: sourceController,
        markdownContent: content,
        isDirty: false,
      );

      // Start auto-save timer
      _startAutoSave();
    } catch (e) {
      // If file doesn't exist, start with empty content
      state = state.copyWith(
        filePath: path,
        fileName: repository.getFileName(path),
        isDirty: false,
      );
    }
  }

  /// Save file
  Future<void> saveFile() async {
    if (state.filePath == null) return;

    try {
      final repository = ref.read(fileRepositoryProvider);
      final markdown = _getCurrentMarkdown();
      
      await repository.writeFile(state.filePath!, markdown);
      
      state = state.copyWith(isDirty: false);
    } catch (e) {
      rethrow;
    }
  }

  /// Toggle editor mode
  void toggleMode(EditorMode newMode) {
    // Sync content between editors when switching modes
    if (state.mode != newMode) {
      final currentMarkdown = _getCurrentMarkdown();
      
      if (newMode == EditorMode.wysiwyg) {
        final delta = _markdownToDelta(currentMarkdown);
        state.quillController?.document = Document.fromDelta(delta);
      } else if (newMode == EditorMode.source) {
        state.sourceController?.text = currentMarkdown;
      }
      
      state = state.copyWith(
        mode: newMode,
        markdownContent: currentMarkdown,
      );
    }
  }

  /// Mark document as dirty
  void markAsDirty() {
    if (!state.isDirty) {
      state = state.copyWith(isDirty: true);
    }
  }

  /// Get current markdown content from active editor
  String _getCurrentMarkdown() {
    switch (state.mode) {
      case EditorMode.wysiwyg:
        return _deltaToMarkdown(state.quillController?.document.toDelta());
      case EditorMode.source:
        return state.sourceController?.text ?? '';
      case EditorMode.preview:
        return state.markdownContent;
    }
  }

  /// Start auto-save timer
  void _startAutoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (state.isDirty && state.filePath != null) {
        saveFile();
      }
    });
  }

  /// Convert markdown to Delta
  Delta _markdownToDelta(String markdown) {
    // Simple markdown to Delta conversion
    // In production, use a proper markdown-to-Delta converter
    final lines = markdown.split('\n');
    final delta = Delta();

    for (final line in lines) {
      if (line.startsWith('# ')) {
        delta.insert(line.substring(2), {'header': 1});
        delta.insert('\n');
      } else if (line.startsWith('## ')) {
        delta.insert(line.substring(3), {'header': 2});
        delta.insert('\n');
      } else if (line.startsWith('- ')) {
        delta.insert(line.substring(2), {'list': 'bullet'});
        delta.insert('\n');
      } else if (line.startsWith('> ')) {
        delta.insert(line.substring(2), {'blockquote': true});
        delta.insert('\n');
      } else {
        delta.insert(line);
        delta.insert('\n');
      }
    }

    return delta;
  }

  /// Convert Delta to markdown
  String _deltaToMarkdown(Delta? delta) {
    if (delta == null) return '';
    
    final buffer = StringBuffer();
    
    for (final op in delta.toList()) {
      final text = op.data?.toString() ?? '';
      final attributes = op.attributes;
      
      if (attributes != null) {
        if (attributes['header'] == 1) {
          buffer.write('# $text\n');
        } else if (attributes['header'] == 2) {
          buffer.write('## $text\n');
        } else if (attributes['bold'] == true) {
          buffer.write('**$text**');
        } else if (attributes['italic'] == true) {
          buffer.write('*$text*');
        } else if (attributes['code'] == true) {
          buffer.write('`$text`');
        } else if (attributes['blockquote'] == true) {
          buffer.write('> $text\n');
        } else if (attributes['list'] == 'bullet') {
          buffer.write('- $text\n');
        } else if (attributes['list'] == 'ordered') {
          buffer.write('1. $text\n');
        } else {
          buffer.write(text);
        }
      } else {
        buffer.write(text);
      }
    }
    
    return buffer.toString();
  }
}
