import 'package:json_path/json_path.dart';
import 'package:json_path/src/predicate.dart';
import 'package:json_path/src/result.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

class Filter with SelectorMixin {
  Filter(this.name, this.predicate);

  final String name;

  final Predicate predicate;

  @override
  Iterable<Result> filter(Iterable<Result> results) =>
      results.where((r) => predicate(r.value));

  @override
  String expression([Selector previous]) => '[?$name]';
}
