import 'package:json_path/src/quote.dart';
import 'package:json_path/src/result.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

class Recursive with SelectorMixin {
  @override
  Iterable<Result> filter(Iterable<Result> results) => results.map((r) {
        if (r.value is Map) return [r].followedBy(_properties(r.value, r.path));
        if (r.value is List) return [r].followedBy(_values(r.value, r.path));
        return <Result>[];
      }).expand((_) => _);

  @override
  String expression([Selector previous]) => '..';

  Iterable<Result> _values(List val, String path) => filter(
      val.asMap().entries.map((e) => Result(e.value, path + '[${e.key}]')));

  Iterable<Result> _properties(Map map, String path) => filter(
      map.entries.map((e) => Result(e.value, path + '[${Quote(e.key)}]')));
}
