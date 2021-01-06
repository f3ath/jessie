/// JSON Pointer (RFC 6901).
class JsonPointer {
  /// Creates a pointer to the root element
  const JsonPointer() : value = '';

  JsonPointer._(this.value);

  /// The string value of the pointer
  final String value;

  /// Returns a new instance of [JsonPointer]
  /// with the [segment] appended at the end.
  JsonPointer append(String segment) => JsonPointer._(
      value + '/' + segment.replaceAll('~', '~0').replaceAll('/', '~1'));

  @override
  String toString() => value;
}
