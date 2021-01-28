import 'package:json_path/src/matching_context.dart';
import 'package:rfc_6901/rfc_6901.dart';

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

  /// The parent match
  JsonPathMatch? get parent;
}
