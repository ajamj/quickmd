software android yang memiliki kemampuan untuk text editing (txt, markdown), disertai markdown. wysiwyg. ide bikin app ini adalah berlatar belakang dari seringnya berinteraksi dengan file markdown, tapi tidak ada default app android yang memiliki kemampuan membuka file tersebut ketika file tsb diklik dari file manager.



---

### 1. Product Requirements Document (PRD) – Tetap Sama (Ringkasan)

**Nama App**: QuickMD  
**Tagline**: “Buka .md atau .txt dari File Manager → langsung edit WYSIWYG. No hassle.”

**Core Features (MVP)** tetap sama seperti sebelumnya:
- File Association (.md & .txt)
- Dual Mode: **Source Mode** (syntax highlight) + **WYSIWYG Mode** (rich text → Markdown)
- Live Preview
- Auto-save + Undo/Redo
- Toolbar Markdown lengkap
- Tema Light/Dark/AMOLED
- Recent Files + Folder Browser (SAF)
- Search & Replace
- Export (HTML, PDF, TXT)

---

### 2. Tech Docs & Architecture (Flutter 3.27+)

#### **Tech Stack (Rekomendasi Terbaru 2026)**

| Layer              | Teknologi                          | Alasan |
|--------------------|------------------------------------|--------|
| **Framework**      | Flutter 3.27+ (Material 3)        | Cross-platform, performa tinggi |
| **Editor Utama**   | **flutter_quill** (v3.x)           | WYSIWYG terbaik, Delta-based, stabil, banyak fitur toolbar |
| **Markdown Parser**| markdown + custom Quill ↔ Markdown converter | Bisa import/export Markdown murni |
| **Preview**        | flutter_markdown + custom renderer | Live preview cepat |
| **File System**    | **docman** (Storage Access Framework) | Handle .md/.txt dari File Manager dengan benar di Android 11+ |
| **State Management** | **Riverpod 2.5+** (with riverpod_annotation) | Clean, testable, performa bagus untuk editor |
| **Routing**        | GoRouter                           | Deep linking & intent mudah |
| **Theme**          | Dynamic Color + FlexColorScheme    | Ikut system + AMOLED support |
| **Persistence**    | Isar (atau Hive)                   | Cache recent files + settings |
| **Syntax Highlight (Source Mode)** | flutter_syntax_highlighter atau CodeField | Untuk mode plain Markdown |
| **Intent Handling**| Custom MethodChannel + docman      | Buka langsung dari File Manager |

**Alternatif Editor jika flutter_quill kurang cocok:**
- `markdown_editor_live` → pure WYSIWYG Markdown (mirip Typora/Obsidian)
- `super_editor` → kalau butuh super custom

Saya saranin **flutter_quill** sebagai utama karena paling matang untuk dual-mode (WYSIWYG + export Markdown).

#### **High-Level Architecture**

```
lib/
├── core/              ← Theme, DI, Utils, Constants
├── features/
│   ├── editor/        ← EditorScreen + QuillController + Riverpod
│   ├── file_browser/  ← Folder picker via docman
│   ├── recent/        ← Recent files
│   └── settings/
├── data/              ← Models (Document, FileInfo), Repositories
├── domain/            ← Use cases
├── presentation/      ← Widgets reusable
├── utils/             ← Markdown converter, file utils
└── main.dart
```

**State Flow**:
- `EditorNotifier` (Riverpod) → manage QuillController + document path + auto-save timer
- Saat buka file via intent → `initialDocumentProvider` baca file → load ke Quill Delta

---

### 3. Cara Implementasi File Association (Paling Penting!)

**1. AndroidManifest.xml** (android/app/src/main/)
```xml
<activity
    android:name=".MainActivity"
    android:exported="true"
    android:launchMode="singleTask">

    <!-- Intent filter untuk buka file .md dan .txt dari File Manager -->
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="content" />
        <data android:scheme="file" />
        <data android:mimeType="text/markdown" />
        <data android:mimeType="text/plain" />
        <data android:mimeType="text/*" />
        <data android:host="*" />
        <data android:pathPattern=".*\\.md" />
        <data android:pathPattern=".*\\.txt" />
    </intent-filter>
</activity>
```

**2. Handle di Flutter**:
- Pakai `docman` untuk baca URI (content:// atau file://)
- Di `main.dart` gunakan `WidgetsBinding.instance.addObserver` atau MethodChannel untuk ambil initial intent
- Atau pakai package `receive_sharing_intent` + custom handler

**3. Flow Buka File**:
1. User klik file .md di File Manager
2. QuickMD terbuka → langsung load file ke editor
3. Auto-detect extension → set mode default (Source atau WYSIWYG)

---

### 4. UI/UX Flow di Flutter

- **Main Screen**: BottomNavigation (Editor | Recent | Browser | Settings)
- **Editor Screen**:
  - AppBar: File name + Save status + Mode toggle (Source ↔ WYSIWYG)
  - Body: `QuillEditor` (WYSIWYG) atau `TextField` + syntax highlight (Source)
  - Bottom sheet / side panel: Live Preview (`flutter_markdown`)
  - Floating Toolbar (seperti Google Docs) atau fixed toolbar di atas keyboard
- **Split View** (opsional di tablet/large screen): pakai `Flex` atau `Row` dengan `flutter_quill` + preview

**Toolbar Markdown** (flutter_quill sudah punya built-in):
- Heading 1-6, Bold, Italic, Strikethrough, Code, Quote
- Bullet list, Numbered list, Task list
- Link, Image (dari gallery atau URL), Table, Horizontal rule

---

### 5. Roadmap Implementasi (MVP 4-6 Minggu)

**Minggu 1**  
- Project init + Riverpod + GoRouter + docman  
- AndroidManifest intent filter  
- Basic file open & save  

**Minggu 2**  
- Integrasi flutter_quill + Markdown converter  
- Dual mode (WYSIWYG + Source) + toggle  

**Minggu 3**  
- Live preview + auto-save (debounce 1 detik)  
- Undo/Redo (sudah built-in Quill)  

**Minggu 4**  
- Toolbar lengkap + Recent files + Folder browser  
- Tema + settings  

**Minggu 5**  
- Search & Replace, Export HTML/PDF  
- Polish UI + testing intent dari berbagai file manager  

**Bonus (Post-MVP)**:
- Git integration (via git package)
- Sync dengan Obsidian vault / Syncthing
- AI assistance (nanti pakai Gemini API)



---

###  Detail Implementasi **EditorNotifier** (Riverpod 2.5+)

Kita pakai **`NotifierProvider`** (bukan AsyncNotifier karena operasi file-nya synchronous + debounce).

**File:** `lib/features/editor/notifier/editor_notifier.dart`

```dart
import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:markdown_quill/markdown_quill.dart'; // ← untuk convert
import '../../../core/utils/file_utils.dart'; // helper SAF / docman

// State yang kita expose
class EditorState {
  final QuillController controller;
  final String? filePath;           // content:// atau file://
  final String fileName;
  final bool isDirty;               // ada perubahan belum disave
  final EditorMode mode;            // wysiwyg / source / preview

  EditorState({
    required this.controller,
    this.filePath,
    this.fileName = 'Untitled.md',
    this.isDirty = false,
    this.mode = EditorMode.wysiwyg,
  });

  EditorState copyWith({
    QuillController? controller,
    String? filePath,
    String? fileName,
    bool? isDirty,
    EditorMode? mode,
  }) {
    return EditorState(
      controller: controller ?? this.controller,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      isDirty: isDirty ?? this.isDirty,
      mode: mode ?? this.mode,
    );
  }
}

enum EditorMode { wysiwyg, source, preview }

final editorProvider = NotifierProvider<EditorNotifier, EditorState>(() {
  return EditorNotifier();
});

class EditorNotifier extends Notifier<EditorState> {
  Timer? _autoSaveTimer;
  QuillController? _controller;

  @override
  EditorState build() {
    _controller = QuillController.basic();
    return EditorState(controller: _controller!);
  }

  // Load file dari intent / file manager
  Future<void> loadFile(String path) async {
    final file = File(path); // atau gunakan docman untuk content://
    final content = await file.readAsString();

    final markdownToDelta = MarkdownToDelta();
    final delta = markdownToDelta.convert(content);

    _controller = QuillController(
      document: Document.fromDelta(delta),
      selection: const TextSelection.collapsed(offset: 0),
    );

    state = state.copyWith(
      controller: _controller!,
      filePath: path,
      fileName: path.split('/').last,
      isDirty: false,
    );

    _startAutoSave();
  }

  // Save file
  Future<void> saveFile() async {
    if (state.filePath == null) return;

    final deltaToMarkdown = DeltaToMarkdown();
    final markdown = deltaToMarkdown.convert(state.controller.document.toDelta());

    await File(state.filePath!).writeAsString(markdown);
    state = state.copyWith(isDirty: false);
  }

  void _startAutoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (state.isDirty && state.filePath != null) {
        saveFile();
      }
    });
  }

  // Toggle mode
  void toggleMode(EditorMode newMode) {
    state = state.copyWith(mode: newMode);
  }

  // Update dirty flag setiap ada perubahan
  void markAsDirty() {
    if (!state.isDirty) {
      state = state.copyWith(isDirty: true);
    }
  }

  // Dispose
  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }
}
```

**Cara pakai di UI:**
```dart
final editorState = ref.watch(editorProvider);
final notifier = ref.read(editorProvider.notifier);

// Di QuillEditor:
QuillEditor(
  controller: editorState.controller,
  ...
  onChange: (_) => notifier.markAsDirty(),
)
```

---

### 3. Cara Convert **Quill Delta ↔ Markdown** (dengan contoh code)

Package terbaik & paling update (2026): **`markdown_quill`**

Tambahkan di `pubspec.yaml`:

```yaml
dependencies:
  flutter_quill: ^10.0.0   # atau versi terbaru
  markdown_quill: ^2.3.0   # pastikan versi paling baru
```

**Contoh lengkap convert (dua arah):**

```dart
import 'package:flutter_quill/flutter_quill.dart';
import 'package:markdown_quill/markdown_quill.dart';

// 1. Delta → Markdown (simpan ke file)
Future<String> deltaToMarkdown(QuillController controller) async {
  final delta = controller.document.toDelta();
  final converter = DeltaToMarkdown();           // dari markdown_quill
  return converter.convert(delta);
}

// 2. Markdown → Delta (buka file)
Delta markdownToDelta(String markdownContent) {
  final converter = MarkdownToDelta(
    // Optional: customisasi embed, table, dll.
    customElementToInlineAttribute: {},
    customElementToBlockAttribute: {},
  );
  return converter.convert(markdownContent);
}

// Contoh full flow di EditorNotifier (sudah saya masukkan di atas)
```

**Customisasi lebih lanjut** (kalau butuh table, task list, dll.):
```dart
final converter = MarkdownToDelta(
  softLineBreak: true,
  customElementToEmbeddable: {
    'image': (element) => Embeddable('image', element.attributes!),
  },
);
```

Package ini support hampir semua GFM (GitHub Flavored Markdown) yang dipakai Quill.

---

### 4. UI Wireframe + Widget Tree (Editor Screen)

**Nama Layar:** `EditorScreen`

**High-level Layout (Portrait):**

```
Scaffold
├── AppBar (fixed)
│   ├── Leading: Back + File Icon
│   ├── Title: fileName + " • Edited" (kalau dirty)
│   ├── Actions: Save (manual), Export, More menu
│   └── SegmentedButton: WYSIWYG | Source | Preview
│
├── Body (expand)
│   └── Conditional berdasarkan state.mode:
│       ├── EditorMode.wysiwyg → QuillEditor + Toolbar
│       ├── EditorMode.source   → CodeField / TextField + syntax highlight
│       └── EditorMode.preview → flutter_markdown (scrollable)
│
├── Bottom Sheet / Floating Toolbar (hanya muncul di WYSIWYG)
│
└── (Opsional) BottomNavigation untuk Recent / Browser
```

**Widget Tree Lengkap (EditorMode.wysiwyg – paling sering dipakai)**

```dart
Scaffold(
  appBar: AppBar(
    title: Text(state.fileName),
    actions: [
      SegmentedButton<EditorMode>(...),
      IconButton(onPressed: notifier.saveFile, icon: Icon(Icons.save)),
    ],
  ),
  body: Column(
    children: [
      // Quill Toolbar (floating atau fixed)
      QuillToolbar.simple(
        configurations: QuillToolbarSimpleConfigurations(
          controller: editorState.controller,
        ),
      ),

      // Editor utama
      Expanded(
        child: QuillEditor(
          controller: editorState.controller,
          configurations: QuillEditorConfigurations(
            padding: EdgeInsets.all(16),
            scrollable: true,
            autoFocus: true,
            expands: true,
          ),
          // onChange untuk markAsDirty
        ),
      ),

      // Live Preview kecil (split bottom) – opsional
      if (isTabletOrLandscape)
        SizedBox(
          height: 250,
          child: flutter_markdown.Markdown(
            data: deltaToMarkdown(editorState.controller), // real-time
          ),
        ),
    ],
  ),

  // Floating Action Button untuk insert image/link cepat
  floatingActionButton: FloatingActionButton.small(
    child: Icon(Icons.add_photo_alternate),
    onPressed: () => _insertImage(),
  ),
)
```

**Source Mode Widget Tree (sederhana):**
```dart
Expanded(
  child: CodeField(                  // atau TextField + highlighter
    controller: TextEditingController(text: currentMarkdown),
    ...
  ),
)
```

**Preview Mode (full screen):**
```dart
flutter_markdown.Markdown(
  data: markdownContent,
  selectable: true,
  styleSheet: MarkdownStyleSheet(...),
)
```

**Responsiveness:**
- Pakai `LayoutBuilder` atau `ResponsiveBuilder`
- Di tablet → otomatis jadi **split view** (Quill kiri + Preview kanan) pakai `Row`

