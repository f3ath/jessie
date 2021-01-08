import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/match_factory.dart';
import 'package:json_path/src/selector/selector.dart';

class Field implements Selector {
  Field(this.name);

  final String name;

  @override
  Iterable<JsonPathMatch> read(JsonPathMatch match) sync* {
    if (match is MapMatch && match.value.containsKey(name)) {
      yield match.child(name);
    }
  }
}
