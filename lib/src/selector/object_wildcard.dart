import 'package:json_path/src/quote.dart';
import 'package:json_path/src/result.dart';
import 'package:json_path/src/selector/recursive.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

class ObjectWildcard with SelectorMixin {
  @override
  Iterable<Result> filter(Iterable<Result> results) => results.map((r) {
        final val = r.value;
        if (val is Map) {
          return val.entries
              .map((e) => Result(e.value, r.path + '[${Quote(e.key)}]'));
        }
        if (val is List) {
          return val
              .asMap()
              .entries
              .map((e) => Result(e.value, r.path + '[${e.key}]'));
        }
        return <Result>[];
      }).expand((_) => _);

  @override
  String expression([Selector previous]) => previous is Recursive ? '*' : '.*';
}
