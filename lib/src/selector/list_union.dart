import 'package:json_path/src/result.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

class ListUnion with SelectorMixin {
  ListUnion(this.keys);

  final List<int> keys;

  @override
  Iterable<Result> filter(Iterable<Result> results) => results
      .map((r) => (r.value is List) ? _map(r.value, r.path) : [])
      .expand((_) => _);

  @override
  String expression([Selector previous]) => '[${keys.join(',')}]';

  Iterable<Result> _map(List list, String path) => keys
      .where((key) => key < list.length)
      .map((key) => Result(list[key], path + '[$key]'));
}
