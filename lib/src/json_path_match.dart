import 'package:json_path/json_pointer.dart';

/// A named filter function
typedef CallbackFilter = bool Function(JsonPathMatch match);

abstract class JsonPathMatch<T> {
  /// The value
  T get value;

  /// JSONPath to this match
  String get path;

  /// JSON Pointer (RFC 6901) to this match
  JsonPointer get pointer;

  /// JSON Path expression
  String get expression;

  /// Returns a callback filter by name
  CallbackFilter? getFilter(String name);
}
