import 'package:json_path/src/id.dart';
import 'package:json_path/src/iterate.dart';
import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector/selector.dart';

class Recursion implements Selector {
  @override
  Iterable<JsonPathMatch> read(JsonPathMatch match) sync* {
    yield match;
    yield* iterate(match.value)
        .where((e) => e.value is Map || e.value is List)
        .map((e) => match.child(e.key, e.value))
        .map(read)
        .expand(id);
  }
}
