import 'package:json_path/src/result.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

class ListUnion with SelectorMixin {
  ListUnion(this.keys);

  final List<int> keys;

  @override
  Iterable<Result> filter(Iterable<Result> results) => results
      .map((r) => (r.value is List) ? mapList(r.value, r.path) : [])
      .expand((_) => _);

  Iterable<Result> mapList(List list, String path) => keys
      .where((key) => key < list.length)
      .map((key) => Result(list[key], path + '[$key]'));

  @override
  String expression([Selector previous]) => '[${keys.join(',')}]';
}
