class TextPaginator {
  static List<String> paginate(String fullContent, {int maxCharactersPerPage = 500}) {
    final List<String> pages = [];
    if (fullContent.trim().isEmpty) return pages;

    final List<String> words = fullContent.split(' ');
    String currentPage = '';

    for (final word in words) {
      final candidate = currentPage.isEmpty ? word : '$currentPage $word';
      if (candidate.length > maxCharactersPerPage && currentPage.isNotEmpty) {
        pages.add(currentPage.trim());
        currentPage = word;
      } else if (word.length > maxCharactersPerPage) {
        // Fallback: tek kelime aşırı uzunsa bölerek sayfalara dağıt
        final chunks = _chunk(word, maxCharactersPerPage);
        for (int i = 0; i < chunks.length; i++) {
          if (i == 0 && currentPage.isNotEmpty) {
            pages.add(currentPage.trim());
          }
          pages.add(chunks[i]);
        }
        currentPage = '';
      } else {
        currentPage = candidate;
      }
    }

    if (currentPage.trim().isNotEmpty) {
      pages.add(currentPage.trim());
    }

    return pages;
  }

  static List<String> _chunk(String text, int size) {
    final List<String> result = [];
    for (int i = 0; i < text.length; i += size) {
      final end = (i + size < text.length) ? i + size : text.length;
      result.add(text.substring(i, end));
    }
    return result;
  }
}


