/// Normalized name selector.
class NameSelector {
  NameSelector(this.name);

  final String name;

  @override
  String toString() => "['${name.escaped}']";
}

extension _StringExt on String {
  /// Returns a string with all characters escaped as unicode entities.
  String get unicodeEscaped =>
      codeUnits.map((c) => '\\u${c.toRadixString(16).padLeft(4, '0')}').join();

  String get escaped => const {
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
          .fold(this, (s, e) => s.replaceAll(e.key, e.value))
          .replaceAllMapped(
              RegExp(r'[\u0000-\u001f]'), (s) => s[0]!.unicodeEscaped);
}
