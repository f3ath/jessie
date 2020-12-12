import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/quote.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

class ObjectWildcard with SelectorMixin implements Selector {
  @override
  Iterable<JsonPathMatch> read(Iterable<JsonPathMatch> matches) =>
      matches.map((r) {
        if (r.value is Map) return _allProperties(r.value, r.path);
        if (r.value is List) return _allValues(r.value, r.path);
        return <JsonPathMatch>[];
      }).expand((_) => _);

  @override
  String expression() => '*';

  Iterable<JsonPathMatch> _allProperties(Map map, String path) => map.entries
      .map((e) => JsonPathMatch(e.value, path + '[${Quote(e.key)}]'));

  Iterable<JsonPathMatch> _allValues(List list, String path) => list
      .asMap()
      .entries
      .map((e) => JsonPathMatch(e.value, path + '[${e.key}]'));

  @override
  dynamic set(json, Replacement replacement) => (json is Map)
      ? json.map((key, value) => MapEntry(key, replacement(value)))
      : json;
}
