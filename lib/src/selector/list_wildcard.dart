import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

class ListWildcard with SelectorMixin implements Selector {
  @override
  Iterable<JsonPathMatch> read(Iterable<JsonPathMatch> matches) => matches
      .where((r) => r.value is List)
      .map((r) => _wrap(r.value, r.path))
      .expand((_) => _);

  @override
  String expression() => '[*]';

  @override
  dynamic set(dynamic json, Replacement replacement) =>
      (json is List) ? json.map(replacement).toList() : json;

  Iterable<JsonPathMatch> _wrap(List val, String path) sync* {
    for (var i = 0; i < val.length; i++) {
      yield JsonPathMatch(val[i], path + '[$i]');
    }
  }
}
