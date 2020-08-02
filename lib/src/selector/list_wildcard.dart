import 'package:json_path/src/result.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

class ListWildcard with SelectorMixin {
  @override
  Iterable<Result> filter(Iterable<Result> results) =>
      results.where((r) => r.value is List).map((r) {
        final val = r.value as List;
        final results = <Result>[];
        for (var i = 0; i < val.length; i++) {
          results.add(Result(val[i], r.path + '[$i]'));
        }
        return results;
      }).expand((_) => _);

  @override
  String expression([Selector previous]) => '[*]';
}
