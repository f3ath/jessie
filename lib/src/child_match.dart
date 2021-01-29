import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/matching_context.dart';
import 'package:json_path/src/quote.dart';
import 'package:rfc_6901/rfc_6901.dart';

/// Creates a match for a child element
class ChildMatch implements JsonPathMatch {
  /// Child match for an array element
  ChildMatch.index(int index, this.parent)
      : value = parent.value[index],
        path = parent.path + '[' + index.toString() + ']',
        pointer = JsonPointerSegment(index.toString(), parent.pointer);

  /// Child match for an object child
  ChildMatch.child(String key, this.parent)
      : value = parent.value[key],
        path = parent.path + '[' + quote(key) + ']',
        pointer = JsonPointerSegment(key, parent.pointer);

  /// The value
  @override
  final value;

  /// JSONPath to this match
  @override
  final String path;

  /// JSON Pointer (RFC 6901) to this match
  @override
  final JsonPointer pointer;

  @override
  MatchingContext get context => parent.context;

  @override
  final JsonPathMatch parent;
}
