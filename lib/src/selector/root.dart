import 'package:json_path/src/result.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

class RootSelector with SelectorMixin implements Selector {
  const RootSelector();

  @override
  Iterable<Result> filter(Iterable<Result> results) =>
      results.map((m) => Result(m.value, expression()));

  @override
  String expression() => r'$';

  @override
  dynamic apply(dynamic json, Function(dynamic _) mutate) {
    return mutate(json);
  }
}
