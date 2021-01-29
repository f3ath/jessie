import 'package:json_path/src/child_match.dart';
import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector.dart';

class Wildcard implements Selector {
  const Wildcard();

  @override
  Iterable<JsonPathMatch> apply(JsonPathMatch match) sync* {
    final value = match.value;
    if (value is Map) {
      yield* value.entries.map((e) => ChildMatch.child(e.key, match));
    }
    if (value is List) {
      yield* value.asMap().entries.map((e) => ChildMatch.index(e.key, match));
    }
  }
}
