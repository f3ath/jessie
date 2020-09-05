import 'package:json_path/src/result.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

class ListUnion with SelectorMixin implements Selector {
  ListUnion(this.keys);

  final List<int> keys;

  @override
  Iterable<Result> filter(Iterable<Result> results) => results
      .map((r) => (r.value is List) ? _map(r.value, r.path) : [])
      .expand((_) => _);

  @override
  String expression() => '[${keys.join(',')}]';

  Iterable<Result> _map(List list, String path) => keys
      .where((key) => key < list.length)
      .map((key) => Result(list[key], path + '[$key]'));

  @override
  dynamic apply(dynamic json, Function(dynamic _) mutate) {
    if (json is List) {
      final applicableKeys = keys.where((key) => json.length > key);
      if (applicableKeys.isEmpty) {
        return json;
      }
      return _mutateInList(json, applicableKeys, mutate);
    }
    return json;
  }

  List _mutateInList(
      List json, Iterable<int> keys, Function(dynamic _) mutate) {
    final copy = [...json];
    keys.forEach((key) {
      copy[key] = mutate(copy[key]);
    });
    return copy;
  }
}
