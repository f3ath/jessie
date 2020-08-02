import 'package:json_path/src/quote.dart';
import 'package:json_path/src/result.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

class ObjectUnion with SelectorMixin {
  ObjectUnion(this.keys);

  final List<String> keys;

  @override
  Iterable<Result> filter(Iterable<Result> results) => results
      .map((r) => (r.value is Map) ? map(r.value, r.path) : [])
      .expand((_) => _);

  Iterable<Result> map(Map map, String path) => keys
      .where(map.containsKey)
      .map((key) => Result(map[key], path + '[${Quote(key)}]'));

  @override
  String expression([Selector previous]) =>
      '[${keys.map((k) => Quote(k)).join(',')}]';
}
