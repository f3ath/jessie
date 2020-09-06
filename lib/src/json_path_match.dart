/// A single matching result
class JsonPathMatch<T> {
  JsonPathMatch(this.value, this.path);

  /// The value
  final T value;

  /// JSONPath to this result
  final String path;
}
