import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/matching_context.dart';
import 'package:json_path/src/quote.dart';
import 'package:rfc_6901/rfc_6901.dart';

class ChildMatch implements JsonPathMatch {
  ChildMatch.index(int index, this.parent)
      : value = parent.value[index],
        path = parent.path + '[' + index.toString() + ']',
        pointer = JsonPointerSegment(index.toString(), parent.pointer),
        context = parent.context;

  ChildMatch.child(String key, this.parent)
      : value = parent.value[key],
        path = parent.path + '[' + quote(key) + ']',
        pointer = JsonPointerSegment(key, parent.pointer),
        context = parent.context;

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
  final MatchingContext context;

  @override
  final JsonPathMatch parent;
}
