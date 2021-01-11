import 'package:json_path/src/path/json_path_match.dart';
import 'package:json_path/src/path/match_factory.dart';
import 'package:json_path/src/path/selector/selector.dart';

class Wildcard implements Selector {
  const Wildcard();

  @override
  Iterable<JsonPathMatch> read(JsonPathMatch match) sync* {
    if (match is MapMatch) {
      yield* match.value.entries.map((e) => match.child(e.key));
    }
    if (match is ListMatch) {
      yield* match.value.asMap().entries.map((e) => match.child(e.key));
    }
  }
}
