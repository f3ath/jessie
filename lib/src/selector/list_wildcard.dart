import 'package:json_path/src/result.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

class ListWildcard with SelectorMixin {
  @override
  Iterable<Result> filter(Iterable<Result> results) => results
      .where((r) => r.value is List)
      .map((r) => _wrap(r.value, r.path))
      .expand((_) => _);

  @override
  String expression([Selector previous]) => '[*]';

  Iterable<Result> _wrap(List val, String path) sync* {
    for (var i = 0; i < val.length; i++) {
      yield Result(val[i], path + '[$i]');
    }
  }
}
