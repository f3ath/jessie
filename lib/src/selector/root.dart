import 'package:json_path/src/result.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

class Root with SelectorMixin {
  const Root();

  @override
  Iterable<Result> filter(Iterable<Result> results) =>
      results.map((m) => Result(m.value, expression()));

  @override
  String expression([Selector previous]) => r'$';
}
