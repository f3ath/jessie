extension StringExt on String {
  /// Returns the string quoted with [quotationMark].
  String quoted({String quotationMark = "'"}) =>
      quotationMark +
      replaceAll(r'/', r'\/')
          .replaceAll(r'\', r'\\')
          .replaceAll('\b', r'\b')
          .replaceAll('\f', r'\f')
          .replaceAll('\n', r'\n')
          .replaceAll('\r', r'\r')
          .replaceAll('\t', r'\t')
          .replaceAll(quotationMark, r'\' + quotationMark) +
      quotationMark;
}
