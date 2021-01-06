String escape(String s) => s
    .replaceAll(r'/', r'\/')
    .replaceAll(r'\', r'\\')
    .replaceAll('\b', r'\b')
    .replaceAll('\f', r'\f')
    .replaceAll('\n', r'\n')
    .replaceAll('\r', r'\r')
    .replaceAll('\t', r'\t');
