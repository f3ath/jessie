/// Quotes a [string] using [quotationMark]
String quote(String string, {String quotationMark = "'"}) =>
    quotationMark +
    string
        .replaceAll(r'/', r'\/')
        .replaceAll(r'\', r'\\')
        .replaceAll('\b', r'\b')
        .replaceAll('\f', r'\f')
        .replaceAll('\n', r'\n')
        .replaceAll('\r', r'\r')
        .replaceAll('\t', r'\t')
        .replaceAll(quotationMark, r'\' + quotationMark) +
    quotationMark;
