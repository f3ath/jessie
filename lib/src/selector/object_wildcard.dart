import 'package:json_path/src/quote.dart';
import 'package:json_path/src/result.dart';
import 'package:json_path/src/selector/recursive.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

class ObjectWildcard with SelectorMixin {
  @override
  Iterable<Result> filter(Iterable<Result> results) => results.map((r) {
        if (r.value is Map) return _allProperties(r.value, r.path);
        if (r.value is List) return _allValues(r.value, r.path);
        return <Result>[];
      }).expand((_) => _);

  @override
  String expression([Selector previous]) => previous is Recursive ? '*' : '.*';

  Iterable<Result> _allProperties(Map map, String path) =>
      map.entries.map((e) => Result(e.value, path + '[${Quote(e.key)}]'));

  Iterable<Result> _allValues(List list, String path) =>
      list.asMap().entries.map((e) => Result(e.value, path + '[${e.key}]'));
}
