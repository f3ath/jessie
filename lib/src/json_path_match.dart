import 'package:json_path/json_pointer.dart';
import 'package:json_path/src/quote.dart';

/// A single matching result
class JsonPathMatch<T> {
  const JsonPathMatch(this.value, this.path, this.pointer);

  /// The value
  final T value;

  /// JSONPath to this match
  final String path;

  /// JSON Pointer (RFC 6901) to this match
  final JsonPointer pointer;

  JsonPathMatch child(dynamic key, dynamic value) => JsonPathMatch(
      value, path + '[' + _quote(key) + ']', pointer.append(key.toString()));

  String _quote(key) => (key is int) ? key.toString() : quote(key.toString());
}
