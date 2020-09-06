import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

class ListUnion with SelectorMixin implements Selector {
  ListUnion(this.keys);

  final List<int> keys;

  @override
  Iterable<JsonPathMatch> read(Iterable<JsonPathMatch> matches) => matches
      .map((r) => (r.value is List) ? _map(r.value, r.path) : [])
      .expand((_) => _);

  @override
  String expression() => '[${keys.join(',')}]';

  Iterable<JsonPathMatch> _map(List list, String path) => keys
      .where((key) => key < list.length)
      .map((key) => JsonPathMatch(list[key], path + '[$key]'));

  @override
  dynamic replace(dynamic json, Function(dynamic _) replacement) {
    if (json is List) {
      final applicableKeys = keys.where((key) => json.length > key);
      if (applicableKeys.isEmpty) {
        return json;
      }
      return _replaceInList(json, applicableKeys, replacement);
    }
    return json;
  }

  List _replaceInList(List list, Iterable<int> keys, Replacement replacement) {
    final copy = [...list];
    keys.forEach((key) {
      copy[key] = replacement(copy[key]);
    });
    return copy;
  }
}
