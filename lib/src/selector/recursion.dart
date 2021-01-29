import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector.dart';
import 'package:json_path/src/selector/wildcard.dart';

class Recursion implements Selector {
  const Recursion();

  @override
  Iterable<JsonPathMatch> apply(JsonPathMatch match) sync* {
    yield match;
    yield* const Wildcard()
        .apply(match)
        .where((e) => e.value is Map || e.value is List)
        .map(apply)
        .expand((_) => _);
  }
}
