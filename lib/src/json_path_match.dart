import 'package:json_path/json_pointer.dart';

/// A single matching result
class JsonPathMatch<T> {
  const JsonPathMatch(this.value, this.path, this.pointer);

  /// The value
  final T value;

  /// JSONPath to this match
  final String path;

  /// JSON Pointer (RFC 6901) to this match
  final JsonPointer pointer;
}
