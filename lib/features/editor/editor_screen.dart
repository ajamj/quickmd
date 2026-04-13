import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../core/di/providers.dart';
import '../../data/repositories/file_repository.dart';
import 'notifier/editor_notifier.dart';

/// Enhanced editor screen with WYSIWYG, Source, and Preview modes
class EditorScreen extends ConsumerStatefulWidget {
  const EditorScreen({super.key});

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  @override
  void initState() {
    super.initState();
    _loadFileFromIntent();
  }

  Future<void> _loadFileFromIntent() async {
    // In a real implementation, this would handle the initial intent
    // from File Manager to get the file path
    // For now, we'll start with an empty document
    
    final notifier = ref.read(editorProvider.notifier);
    // Uncomment when intent handling is implemented:
    // if (filePath != null) {
    //   await notifier.loadFile(filePath);
    // }
  }

  Future<void> _saveFile() async {
    try {
      final notifier = ref.read(editorProvider.notifier);
      await notifier.saveFile();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final editorState = ref.watch(editorProvider);
    final notifier = ref.read(editorProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(editorState.fileName),
            if (editorState.isDirty)
              const Text(
                'Edited',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.orange,
                ),
              ),
          ],
        ),
        actions: [
          // Mode toggle
          SegmentedButton<EditorMode>(
            segments: const [
              ButtonSegment(
                value: EditorMode.wysiwyg,
                label: Text('WYSIWYG'),
                icon: Icon(Icons.edit),
              ),
              ButtonSegment(
                value: EditorMode.source,
                label: Text('Source'),
                icon: Icon(Icons.code),
              ),
              ButtonSegment(
                value: EditorMode.preview,
                label: Text('Preview'),
                icon: Icon(Icons.visibility),
              ),
            ],
            selected: {editorState.mode},
            onSelectionChanged: (newMode) {
              notifier.toggleMode(newMode.first);
            },
          ),
          const SizedBox(width: 8),
          // Save button
          if (editorState.isDirty)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveFile,
              tooltip: 'Save',
            ),
        ],
      ),
      body: _buildEditorBody(editorState, notifier),
    );
  }

  Widget _buildEditorBody(EditorState state, EditorNotifier notifier) {
    switch (state.mode) {
      case EditorMode.wysiwyg:
        return _buildWYSIWYGEditor(state, notifier);
      case EditorMode.source:
        return _buildSourceEditor(state, notifier);
      case EditorMode.preview:
        return _buildPreviewer(state);
    }
  }

  Widget _buildWYSIWYGEditor(EditorState state, EditorNotifier notifier) {
    return Column(
      children: [
        // Quill toolbar
        QuillToolbar.simple(
          configurations: QuillToolbarSimpleConfigurations(
            controller: state.quillController!,
            toolbarIconAlignment: WrapAlignment.start,
            toolbarSectionSpacing: 8,
          ),
        ),
        const Divider(height: 1),
        
        // Quill editor
        Expanded(
          child: QuillEditor.basic(
            configurations: QuillEditorConfigurations(
              controller: state.quillController!,
              padding: const EdgeInsets.all(16),
              scrollable: true,
              autoFocus: true,
              expands: true,
              readOnly: false,
            ),
            onChanged: (_) {
              notifier.markAsDirty();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSourceEditor(EditorState state, EditorNotifier notifier) {
    return TextField(
      controller: state.sourceController,
      maxLines: null,
      expands: true,
      textAlignVertical: TextAlignVertical.top,
      style: const TextStyle(
        fontFamily: 'monospace',
        fontSize: 14,
      ),
      decoration: const InputDecoration(
        hintText: 'Enter markdown here...',
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(16),
      ),
      onChanged: (_) {
        notifier.markAsDirty();
      },
    );
  }

  Widget _buildPreviewer(EditorState state) {
    final markdownContent = state.markdownContent;
    
    return Markdown(
      data: markdownContent,
      padding: const EdgeInsets.all(16),
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        h1: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        h2: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        h3: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        code: const TextStyle(
          fontFamily: 'monospace',
          backgroundColor: Colors.grey[200],
        ),
        codeblockDecoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Cleanup is handled by the notifier
    super.dispose();
  }
}
