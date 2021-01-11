import 'package:json_path/src/path/json_path_match.dart';
import 'package:json_path/src/path/match_factory.dart';
import 'package:json_path/src/path/selector/selector.dart';

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
