import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/providers.dart';
import '../../data/repositories/file_repository.dart';

/// Editor screen for opening and editing markdown/text files
class EditorScreen extends ConsumerStatefulWidget {
  const EditorScreen({super.key});

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isModified = false;

  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  Future<void> _loadFile() async {
    final filePath = ref.read(filePathProvider);
    if (filePath == null) {
      // New file - start with empty content
      return;
    }

    try {
      final repository = ref.read(fileRepositoryProvider);
      final content = await repository.readFile(filePath);
      
      if (mounted) {
        _controller.text = content;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load file: $e')),
        );
      }
    }
  }

  Future<void> _saveFile() async {
    final filePath = ref.read(filePathProvider);
    if (filePath == null) return;

    try {
      final repository = ref.read(fileRepositoryProvider);
      await repository.writeFile(filePath, _controller.text);
      
      if (mounted) {
        setState(() {
          _isModified = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save file: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filePath = ref.watch(filePathProvider);
    final fileName = filePath != null 
        ? filePath.split('/').last 
        : 'Untitled.md';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(fileName),
            if (_isModified)
              const Text(
                'Edited',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
          ],
        ),
        actions: [
          if (_isModified)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveFile,
              tooltip: 'Save',
            ),
        ],
      ),
      body: TextField(
        controller: _controller,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        decoration: const InputDecoration(
          hintText: 'Start typing...',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
        onChanged: (_) {
          if (!_isModified) {
            setState(() {
              _isModified = true;
            });
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
