import 'package:json_path/src/path/json_path_match.dart';
import 'package:json_path/src/path/selector/selector.dart';
import 'package:json_path/src/path/selector/wildcard.dart';

class Recursion implements Selector {
  const Recursion();

  @override
  Iterable<JsonPathMatch> read(JsonPathMatch match) sync* {
    yield match;
    yield* const Wildcard()
        .read(match)
        .where((e) => e.value is Map || e.value is List)
        .map(read)
        .expand((_) => _);
  }
}
