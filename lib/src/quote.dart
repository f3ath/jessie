/// A single-quoted string.
/// Example:
/// `hello` => `'hello'`
/// `i'm \ok` => `'i\'m \\ok'`
class Quote {
  Quote(String value)
      : value =
            "'" + value.replaceAll(r'\', r'\\').replaceAll("'", r"\'") + "'";

  final String value;

  @override
  String toString() => value;
}
