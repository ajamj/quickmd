# QuickMD

> **Buka .md atau .txt dari File Manager → langsung edit WYSIWYG. No hassle.**

QuickMD adalah aplikasi Android yang memungkinkan Anda membuka file markdown (.md) dan teks (.txt) langsung dari File Manager dengan kemampuan editing WYSIWYG. Dibangun dengan Flutter, menyediakan editing dual-mode (Source + WYSIWYG), live preview, dan file association yang seamless.

## ✨ Fitur

- **File Association** - Buka file .md dan .txt langsung dari File Manager
- **Dual Mode Editing** - Mode Source (syntax highlight) + Mode WYSIWYG (rich text → Markdown)
- **Live Preview** - Preview markdown secara real-time
- **Auto-save** - Simpan otomatis dengan debounce
- **Undo/Redo** - Dukungan undo/redo penuh
- **Toolbar Markdown** - Toolbar lengkap (H1-H6, Bold, Italic, Code, Lists, Links, Images, Tables)
- **Theme Support** - Light/Dark/System themes
- **Settings** - Pengaturan tema dan preferensi
- **Search & Replace** - Cari dan ganti teks dalam dokumen

## 🛠️ Tech Stack

| Layer | Teknologi | Alasan |
|-------|-----------|--------|
| **Framework** | Flutter 3.41+ (Material 3) | Cross-platform, performa tinggi |
| **Editor** | flutter_quill 11.5+ | WYSIWYG terbaik, Delta-based |
| **Markdown** | flutter_markdown + markdown | Preview dan parsing cepat |
| **State Management** | Riverpod 2.6+ | Clean, testable, performa bagus |
| **Navigation** | GoRouter | Routing modern |
| **Theme** | Material 3 native | Ikut system theme |

## 📦 Instalasi

### Prerequisites

- Flutter 3.27+ 
- Dart 3.11+
- Android SDK 31+

### Setup

```bash
# Clone repository
git clone https://github.com/ajamj/quickmd.git
cd quickmd

# Install dependencies
flutter pub get

# Jalankan aplikasi
flutter run
```

### Build APK

```bash
# Build APK release
flutter build apk --release

# APK akan ada di build/app/outputs/flutter-apk/app-release.apk
```

## 🏗️ Struktur Project

```
lib/
├── core/                    # Core utilities dan configuration
│   ├── di/                  # Dependency injection (Riverpod providers)
│   ├── theme/               # Theme configuration
│   └── utils/               # Utilities (file handling, dll)
├── data/                    # Data layer
│   └── repositories/        # File operations repository
├── features/                # Features
│   ├── editor/              # Editor screen + notifier
│   │   ├── editor_screen.dart
│   │   ├── notifier/
│   │   └── search/
│   └── settings/            # Settings screen
├── presentation/            # Presentation layer
│   └── main_screen.dart     # Main navigation
└── main.dart                # App entry point
```

## 🧪 Testing

```bash
# Run semua tests
flutter test

# Run dengan coverage
flutter test --coverage
```

**Status:** 23 tests passing ✅

## 📝 Roadmap

- [x] Phase 1: Foundation & File Opening
- [x] Phase 2: Core Editor (WYSIWYG + Source mode)
- [x] Phase 3: Live Features (Preview, Auto-save, Undo/Redo)
- [x] Phase 4: Polish & Settings (Themes, Navigation)
- [x] Phase 5: Advanced Features (Search & Replace)
- [ ] Phase 6: MVP Release (Testing, optimization, release build)

## 🤝 Contributing

Contributions sangat dihargai! Silakan:

1. Fork repository
2. Buat branch fitur (`git checkout -b feature/amazing-feature`)
3. Commit perubahan (`git commit -m 'feat: add amazing feature'`)
4. Push ke branch (`git push origin feature/amazing-feature`)
5. Buat Pull Request

## 📄 License

Project ini opensource dan tersedia di bawah MIT License.

## 👤 Author

- **ajamj** - [GitHub](https://github.com/ajamj)

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev/) - Framework UI
- [flutter_quill](https://github.com/singerdmx/flutter-quill) - Rich text editor
- [Riverpod](https://riverpod.dev/) - State management
- Semua kontributor opensource yang membuat project ini mungkin

---

**QuickMD** - Buka, Edit, Simpan. Semudah itu.
