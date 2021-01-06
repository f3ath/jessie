import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector/selector.dart';

/// Reads zero or more values from the given object
abstract class Reader {
  Iterable read(dynamic object);
}

/// Reads the value from a [Map] by key
class FieldReader implements Reader {
  FieldReader(this.key);

  final String key;

  @override
  Iterable read(object) {
    if (object is Map && object.containsKey(key)) return [object[key]];
    return [];
  }
}

class DotField implements Selector {
  DotField(this.name);

  final String name;

  @override
  Iterable<JsonPathMatch> read(Iterable<JsonPathMatch> matches) => matches
      .map((m) => FieldReader(name).read(m.value).map(
          (v) => JsonPathMatch(v, m.path + '.$name', m.pointer.append(name))))
      .expand((_) => _);
}
