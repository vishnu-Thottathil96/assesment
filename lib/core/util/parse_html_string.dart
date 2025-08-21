String parseHtmlString(String htmlString) {
  // Remove all HTML tags
  final regex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
  return htmlString.replaceAll(regex, '');
}
