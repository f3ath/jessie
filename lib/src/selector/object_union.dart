import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector/quote.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

class ObjectUnion with SelectorMixin implements Selector {
  ObjectUnion(List<String> keys) : _keys = keys.toSet().toList();

  final List<String> _keys;

  @override
  Iterable<JsonPathMatch> read(Iterable<JsonPathMatch> matches) => matches
      .map((r) =>
          (r.value is Map) ? _readMap(r.value, r.path) : <JsonPathMatch>[])
      .expand((_) => _);

  @override
  String expression() => '[${_keys.map((k) => Quote(k)).join(',')}]';

  @override
  dynamic set(dynamic json, Replacement replacement) {
    if (json == null) return _patch(<String, dynamic>{}, replacement);
    if (json is Map) return {...json, ..._patch(json, replacement)};
    return json;
  }

  Iterable<JsonPathMatch> _readMap(Map map, String path) => _keys
      .where(map.containsKey)
      .map((key) => JsonPathMatch(map[key], path + '[${Quote(key)}]'));

  Map _patch(Map map, Replacement replacement) =>
      Map.fromEntries(_keys.map((key) => MapEntry(key, replacement(map[key]))));
}
