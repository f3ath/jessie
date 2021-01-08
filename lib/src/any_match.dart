import 'package:json_path/json_pointer.dart';
import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/matching_context.dart';

class AnyMatch<T> implements JsonPathMatch<T> {
  const AnyMatch(this.value, this.path, this.pointer, this.context);

  /// The value
  @override
  final T value;

  /// JSONPath to this match
  @override
  final String path;

  /// JSON Pointer (RFC 6901) to this match
  @override
  final JsonPointer pointer;

  final MatchingContext context;

  /// JSON Path expression
  @override
  String get expression => context.expression;

  /// Returns a callback filter by name
  @override
  CallbackFilter? getFilter(String name) => context.filter[name];
}
