import 'package:json_path/src/quote.dart';
import 'package:json_path/src/result.dart';
import 'package:json_path/src/selector/selector.dart';

class ObjectUnion extends Selector {
  ObjectUnion(this.keys);

  final List<String> keys;

  @override
  Iterable<Result> call(Iterable<Result> results) => results
      .map((r) => (r.value is Map) ? map(r.value, r.path) : [])
      .expand((_) => _);

  Iterable<Result> map(Map map, String path) => keys
      .where(map.containsKey)
      .map((key) => Result(map[key], path + '[${Quote(key)}]'));

  @override
  String get expression => '[${keys.map((k) => Quote(k)).join(',')}]';
}
