import 'package:json_path/json_path.dart';
import 'package:json_path/src/predicate.dart';
import 'package:json_path/src/result.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

class Filter with SelectorMixin implements Selector {
  Filter(this.name, this.predicate);

  final String name;

  final Predicate predicate;

  @override
  Iterable<Result> filter(Iterable<Result> results) =>
      results.where((r) => predicate(r.value));

  @override
  String expression() => '[?$name]';

  @override
  dynamic apply(dynamic json,  Function(dynamic _) mutate) {
    if (predicate(json)) {
      return mutate(json);
    }
    return json;
  }
}
