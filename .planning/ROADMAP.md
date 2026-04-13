# Roadmap: QuickMD

**Created:** 2026-04-13
**Core Value:** Open .md or .txt from File Manager → directly edit WYSIWYG. No hassle.

## Phase 1: Foundation & File Opening

**Goal:** Project setup, file association working, basic open/save

**Deliverables:**
- Flutter project initialized with Material 3
- Riverpod 2.5+ integrated
- GoRouter configured
- docman integrated for SAF file access
- AndroidManifest intent filters for .md/.txt
- Basic file open from File Manager
- Basic file save functionality
- Main screen scaffold with navigation

**Requirements:** FILE-01, FILE-02, FILE-03, FILE-04, FILE-OP-01

**Dependencies:** None (first phase)

---

## Phase 2: Core Editor

**Goal:** Dual-mode editor with markdown toolbar

**Deliverables:**
- flutter_quill integrated
- Markdown ↔ Quill Delta converter
- WYSIWYG mode with toolbar
- Source mode with syntax highlighting
- Mode toggle (WYSIWYG ↔ Source ↔ Preview)
- Complete markdown toolbar (H1-H6, Bold, Italic, Code, Quote, Lists, Links, Images, Tables)

**Requirements:** EDIT-01, EDIT-02, EDIT-03, EDIT-04

**Dependencies:** Phase 1 (needs file loading)

---

## Phase 3: Live Features

**Goal:** Live preview, auto-save, undo/redo

**Deliverables:**
- Live preview panel (flutter_markdown)
- Auto-save with debounce timer
- Undo/Redo implementation
- Dirty state tracking
- Save status indicator in UI

**Requirements:** EDIT-05, EDIT-06, FILE-OP-02

**Dependencies:** Phase 2 (needs editor working)

---

## Phase 4: Polish & Settings

**Goal:** Themes, settings, recent files, folder browser

**Deliverables:**
- Light/Dark/AMOLED theme support
- Dynamic Color integration
- Settings screen
- Recent files list (Isar/Hive cache)
- Folder browser via SAF
- Default editor mode setting

**Requirements:** THEME-01, THEME-02, THEME-03, THEME-04, SETTINGS-01, SETTINGS-02, FILE-OP-06

**Dependencies:** Phase 3 (core features stable)

---

## Phase 5: Advanced Features

**Goal:** Search & replace, export options

**Deliverables:**
- Search functionality
- Replace functionality
- Export to HTML
- Export to PDF
- Export to TXT
- UI polish across all screens
- Intent handling from various file managers

**Requirements:** SEARCH-01, SEARCH-02, FILE-OP-03, FILE-OP-04, FILE-OP-05

**Dependencies:** Phase 4 (all core features complete)

---

## Phase 6: MVP Release

**Goal:** Final polish, testing, release preparation

**Deliverables:**
- Integration testing
- Bug fixes
- Performance optimization
- App icon and branding
- Release build configuration
- README and documentation

**Requirements:** All v1 requirements validated

**Dependencies:** Phase 5 (all features complete)

---

## Progress

| Phase | Status | Plans | Progress |
|-------|--------|-------|----------|
| 1 | ○ | 0/1 | 0% |
| 2 | ○ | 0/1 | 0% |
| 3 | ○ | 0/1 | 0% |
| 4 | ○ | 0/1 | 0% |
| 5 | ○ | 0/1 | 0% |
| 6 | ○ | 0/1 | 0% |

---
*Roadmap created: 2026-04-13*
*Last updated: 2026-04-13 after initial definition*
