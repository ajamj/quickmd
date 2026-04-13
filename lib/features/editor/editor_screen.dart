import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../core/di/providers.dart';
import 'notifier/editor_notifier.dart' as editor_notifier;

/// Enhanced editor screen with WYSIWYG, Source, and Preview modes
class EditorScreen extends ConsumerStatefulWidget {
  const EditorScreen({super.key});

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  @override
  Widget build(BuildContext context) {
    final editorState = ref.watch(editor_notifier.editorProvider);
    final notifier = ref.read(editor_notifier.editorProvider.notifier);

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
          SegmentedButton<editor_notifier.EditorMode>(
            segments: const [
              ButtonSegment(
                value: editor_notifier.EditorMode.wysiwyg,
                label: Text('WYSIWYG'),
                icon: Icon(Icons.edit),
              ),
              ButtonSegment(
                value: editor_notifier.EditorMode.source,
                label: Text('Source'),
                icon: Icon(Icons.code),
              ),
              ButtonSegment(
                value: editor_notifier.EditorMode.preview,
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
              onPressed: () async {
                try {
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
              },
              tooltip: 'Save',
            ),
        ],
      ),
      body: _buildEditorBody(editorState, notifier),
    );
  }

  Widget _buildEditorBody(
    editor_notifier.EditorState state,
    editor_notifier.EditorNotifier notifier,
  ) {
    switch (state.mode) {
      case editor_notifier.EditorMode.wysiwyg:
        return _buildWYSIWYGEditor(state, notifier);
      case editor_notifier.EditorMode.source:
        return _buildSourceEditor(state, notifier);
      case editor_notifier.EditorMode.preview:
        return _buildPreviewer(state);
    }
  }

  Widget _buildWYSIWYGEditor(
    editor_notifier.EditorState state,
    editor_notifier.EditorNotifier notifier,
  ) {
    return Column(
      children: [
        // Quill toolbar
        QuillSimpleToolbar(
          controller: state.quillController!,
          config: const QuillSimpleToolbarConfig(),
        ),
        const Divider(height: 1),
        // Quill editor
        Expanded(
          child: QuillEditor.basic(
            controller: state.quillController!,
            config: QuillEditorConfig(
              padding: const EdgeInsets.all(16),
              scrollable: true,
              autoFocus: true,
              expands: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSourceEditor(
    editor_notifier.EditorState state,
    editor_notifier.EditorNotifier notifier,
  ) {
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

  Widget _buildPreviewer(editor_notifier.EditorState state) {
    final markdownContent = state.markdownContent;

    return Markdown(
      data: markdownContent,
      padding: const EdgeInsets.all(16),
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        h1: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        h2: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        h3: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        code: TextStyle(
          fontFamily: 'monospace',
          backgroundColor: Colors.grey.shade200,
        ),
        codeblockDecoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
