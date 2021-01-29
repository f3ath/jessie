import 'package:json_path/src/child_match.dart';
import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector.dart';

class Field implements Selector {
  Field(this.name);

  final String name;

  @override
  Iterable<JsonPathMatch> read(JsonPathMatch match) sync* {
    final value = match.value;
    if (value is Map && value.containsKey(name)) {
      yield ChildMatch.child(name, match);
    }
  }
}
