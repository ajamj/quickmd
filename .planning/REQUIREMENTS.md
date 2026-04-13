# Requirements: QuickMD

**Defined:** 2026-04-13
**Core Value:** Open .md or .txt from File Manager → directly edit WYSIWYG. No hassle.

## v1 Requirements

### File Association

- [ ] **FILE-01**: App opens when user clicks .md file in File Manager
- [ ] **FILE-02**: App opens when user clicks .txt file in File Manager
- [ ] **FILE-03**: File content loads correctly into editor
- [ ] **FILE-04**: Handles both content:// and file:// URI schemes

### Editor

- [ ] **EDIT-01**: User can edit document in WYSIWYG mode
- [ ] **EDIT-02**: User can toggle between WYSIWYG, Source, and Preview modes
- [ ] **EDIT-03**: Markdown toolbar provides formatting options (H1-H6, Bold, Italic, Code, Quote, Lists, Links, Images, Tables)
- [ ] **EDIT-04**: Source mode shows syntax-highlighted markdown
- [ ] **EDIT-05**: Live preview renders markdown correctly
- [ ] **EDIT-06**: Undo/Redo works correctly in all modes

### File Operations

- [ ] **FILE-OP-01**: User can save document to original location
- [ ] **FILE-OP-02**: Auto-save triggers on content changes (debounce ~1-2 seconds)
- [ ] **FILE-OP-03**: User can export document to HTML
- [ ] **FILE-OP-04**: User can export document to PDF
- [ ] **FILE-OP-05**: User can export document to TXT
- [ ] **FILE-OP-06**: Recent files list shows last opened documents

### Theme & Settings

- [ ] **THEME-01**: App supports Light mode
- [ ] **THEME-02**: App supports Dark mode
- [ ] **THEME-03**: App supports AMOLED Dark theme
- [ ] **THEME-04**: Theme follows system dynamic color (if available)
- [ ] **SETTINGS-01**: User can configure default editor mode
- [ ] **SETTINGS-02**: User can browse folders via Storage Access Framework

### Search

- [ ] **SEARCH-01**: User can search for text in document
- [ ] **SEARCH-02**: User can replace text in document

## v2 Requirements

Deferred to future release. Tracked but not in current roadmap.

### Advanced Features

- **ADV-01**: Git integration for version control
- **ADV-02**: Sync with Obsidian vault
- **ADV-03**: Sync with Syncthing
- **ADV-04**: AI assistance via Gemini API
- **ADV-05**: Split view on tablets
- **ADV-06**: Table of contents generation

### Platform Expansion

- **PLATFORM-01**: iOS version
- **PLATFORM-02**: Desktop version (Windows/Mac/Linux)

## Out of Scope

| Feature | Reason |
|---------|--------|
| Real-time collaboration | High complexity, not core to single-user editing |
| Cloud storage integration | Defer to v2+, focus on local files first |
| Custom markdown flavors | Standard GFM sufficient for v1 |
| Plugin system | Too complex for MVP |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| FILE-01 | Phase 1 | Pending |
| FILE-02 | Phase 1 | Pending |
| FILE-03 | Phase 1 | Pending |
| FILE-04 | Phase 1 | Pending |
| FILE-OP-01 | Phase 1 | Pending |
| EDIT-01 | Phase 2 | Pending |
| EDIT-02 | Phase 2 | Pending |
| EDIT-03 | Phase 2 | Pending |
| EDIT-04 | Phase 2 | Pending |
| EDIT-05 | Phase 3 | Pending |
| EDIT-06 | Phase 3 | Pending |
| FILE-OP-02 | Phase 3 | Pending |
| FILE-OP-03 | Phase 5 | Pending |
| FILE-OP-04 | Phase 5 | Pending |
| FILE-OP-05 | Phase 5 | Pending |
| FILE-OP-06 | Phase 4 | Pending |
| THEME-01 | Phase 4 | Pending |
| THEME-02 | Phase 4 | Pending |
| THEME-03 | Phase 4 | Pending |
| THEME-04 | Phase 4 | Pending |
| SETTINGS-01 | Phase 4 | Pending |
| SETTINGS-02 | Phase 4 | Pending |
| SEARCH-01 | Phase 5 | Pending |
| SEARCH-02 | Phase 5 | Pending |

**Coverage:**
- v1 requirements: 24 total
- Mapped to phases: 24
- Unmapped: 0 ✓

---
*Requirements defined: 2026-04-13*
*Last updated: 2026-04-13 after initial definition*
