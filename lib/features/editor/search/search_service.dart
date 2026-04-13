/// Search result match
class SearchMatch {
  final int start;
  final int end;
  final String text;

  SearchMatch({
    required this.start,
    required this.end,
    required this.text,
  });
}

/// Service for search and replace operations
class SearchService {
  String _sourceText = '';
  List<SearchMatch> _matches = [];
  int _currentIndex = -1;

  /// Set the source text to search in
  void setSourceText(String text) {
    _sourceText = text;
    _matches = [];
    _currentIndex = -1;
  }

  /// Find all occurrences of term in source text
  List<SearchMatch> findAll(String term, {bool caseSensitive = false}) {
    if (term.isEmpty) {
      return [];
    }

    _matches = [];
    _currentIndex = -1;

    String searchText = caseSensitive ? _sourceText : _sourceText.toLowerCase();
    String searchTerm = caseSensitive ? term : term.toLowerCase();

    int startIndex = 0;
    while (true) {
      int index = searchText.indexOf(searchTerm, startIndex);
      if (index == -1) break;

      _matches.add(SearchMatch(
        start: index,
        end: index + term.length,
        text: _sourceText.substring(index, index + term.length),
      ));

      startIndex = index + term.length;
    }

    return _matches;
  }

  /// Replace first occurrence
  String replaceFirst(String searchTerm, String replacement) {
    if (_sourceText.isEmpty || searchTerm.isEmpty) {
      return _sourceText;
    }

    final index = _sourceText.toLowerCase().indexOf(searchTerm.toLowerCase());
    if (index == -1) return _sourceText;

    return _sourceText.replaceRange(
      index,
      index + searchTerm.length,
      replacement,
    );
  }

  /// Replace all occurrences
  String replaceAll(String searchTerm, String replacement) {
    if (_sourceText.isEmpty || searchTerm.isEmpty) {
      return _sourceText;
    }

    final regex = RegExp(searchTerm, caseSensitive: false);
    return _sourceText.replaceAll(regex, replacement);
  }

  /// Get current matches
  List<SearchMatch> get matches => List.unmodifiable(_matches);

  /// Get current match index
  int get currentIndex => _currentIndex;

  /// Navigate to next match
  int nextMatch() {
    if (_matches.isEmpty) return -1;
    _currentIndex = (_currentIndex + 1) % _matches.length;
    return _currentIndex;
  }

  /// Navigate to previous match
  int previousMatch() {
    if (_matches.isEmpty) return -1;
    _currentIndex = (_currentIndex - 1 + _matches.length) % _matches.length;
    return _currentIndex;
  }
}
