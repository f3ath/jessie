import 'package:json_path/json_pointer.dart';
import 'package:json_path/src/matching_context.dart';

/// A named filter function
typedef CallbackFilter = bool Function(JsonPathMatch match);

abstract class JsonPathMatch<T> {
  /// The value
  T get value;

  /// JSONPath to this match
  String get path;

  /// JSON Pointer (RFC 6901) to this match
  JsonPointer get pointer;

  /// Matching context
  MatchingContext get context;
}
