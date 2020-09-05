import 'package:json_path/src/quote.dart';
import 'package:json_path/src/result.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

class ObjectUnion with SelectorMixin implements Selector {
  ObjectUnion(this.keys);

  final List<String> keys;

  @override
  Iterable<Result> filter(Iterable<Result> results) => results
      .map((r) => (r.value is Map) ? _map(r.value, r.path) : <Result>[])
      .expand((_) => _);

  @override
  String expression() => '[${keys.map((k) => Quote(k)).join(',')}]';

  Iterable<Result> _map(Map map, String path) => keys
      .where(map.containsKey)
      .map((key) => Result(map[key], path + '[${Quote(key)}]'));

  @override
  dynamic apply(dynamic json, dynamic Function(dynamic _) mutate) {
    if (json is Map) {
      final diff = Map.fromEntries(keys
          .where(json.containsKey)
          .map((key) => MapEntry(key, mutate(json[key]))));
      if (diff.isEmpty) {
        return json;
      }
      return {...json, ...diff};
    }
    return json;
  }
}
