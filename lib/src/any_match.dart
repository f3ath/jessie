import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/matching_context.dart';
import 'package:rfc_6901/rfc_6901.dart';

class AnyMatch<T> implements JsonPathMatch<T> {
  const AnyMatch(
      {required this.value,
      required this.path,
      required this.pointer,
      required this.context,
      this.parent});

  /// The value
  @override
  final T value;

  /// JSONPath to this match
  @override
  final String path;

  /// JSON Pointer (RFC 6901) to this match
  @override
  final JsonPointer pointer;

  @override
  final MatchingContext context;

  @override
  final JsonPathMatch? parent;
}
