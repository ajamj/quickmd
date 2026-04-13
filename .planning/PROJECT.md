# QuickMD

## What This Is

QuickMD is an Android app that opens .md and .txt files directly from File Manager with WYSIWYG editing capability. Built with Flutter, it provides dual-mode editing (Source + WYSIWYG), live preview, and seamless file association - solving the problem of no default Android app for markdown files.

## Core Value

Open .md or .txt from File Manager → directly edit WYSIWYG. No hassle.

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] File Association - Opens .md and .txt files from File Manager via intent
- [ ] Dual Mode Editing - Source Mode (syntax highlight) + WYSIWYG Mode (rich text → Markdown)
- [ ] Live Preview - Real-time markdown rendering preview
- [ ] Auto-save + Undo/Redo - Automatic save with debounce, full undo/redo support
- [ ] Markdown Toolbar - Complete toolbar (headings, bold, italic, code, lists, links, images, tables)
- [ ] Theme Support - Light/Dark/AMOLED themes with Dynamic Color
- [ ] Recent Files + Folder Browser - File management with SAF integration
- [ ] Search & Replace - Find and replace text in documents
- [ ] Export - Export to HTML, PDF, TXT formats

### Out of Scope

- Git integration — High complexity, defer to post-MVP
- Sync with Obsidian vault / Syncthing — Complex integration, post-MVP
- AI assistance — Requires external API, post-MVP
- iOS version — Android-first strategy

## Context

User frequently interacts with markdown files on Android but lacks a default app that opens .md files when clicked from File Manager. Current Android ecosystem gap for markdown editing.

**Tech Stack (Decisions Pending Validation):**
- Framework: Flutter 3.27+ (Material 3)
- Editor: flutter_quill (v3.x) for WYSIWYG
- Markdown: markdown + custom Quill ↔ Markdown converter
- File System: docman (Storage Access Framework)
- State Management: Riverpod 2.5+
- Routing: GoRouter
- Theme: Dynamic Color + FlexColorScheme
- Persistence: Isar or Hive for cache

## Constraints

- **Platform**: Android 11+ — Storage Access Framework requirements for file access
- **Performance**: Must open files quickly from File Manager intent
- **Compatibility**: Must handle both content:// and file:// URI schemes

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Flutter over native Android | Cross-platform potential, Material 3 support | — Pending |
| flutter_quill as WYSIWYG editor | Most mature Delta-based editor, stable | — Pending |
| Riverpod 2.5+ for state | Clean, testable, good performance | — Pending |
| docman for file access | Proper SAF handling for Android 11+ | — Pending |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd:transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd:complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-04-13 after initialization*
