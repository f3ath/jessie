import 'package:json_path/src/iterate.dart';
import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector/selector.dart';

class Wildcard implements Selector {
  const Wildcard();

  @override
  Iterable<JsonPathMatch> read(JsonPathMatch match) =>
      iterate(match.value).map((e) => match.child(e.key, e.value));


}
