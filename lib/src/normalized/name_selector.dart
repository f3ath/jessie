class NameSelector {
  NameSelector(this.name);

  final String name;

  @override
  String toString() => "['${_escape(name)}']";

  String _escape(String string) => {
        r'/': r'\/',
        r'\': r'\\',
        '\b': r'\b',
        '\f': r'\f',
        '\n': r'\n',
        '\r': r'\r',
        '\t': r'\t',
        "'": r"\'",
      }
          .entries
          .fold(string, (s, e) => s.replaceAll(e.key, e.value))
          .replaceAllMapped(
              RegExp(r'[\u0000-\u001f]'),
              (s) =>
                  '\\u${s[0]!.codeUnitAt(0).toRadixString(16).padLeft(4, '0')}');
}
