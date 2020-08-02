import 'package:json_path/src/quote.dart';
import 'package:json_path/src/result.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

class Field with SelectorMixin {
  Field(this.name);

  final String name;

  @override
  Iterable<Result> filter(Iterable<Result> results) => results
      .where((r) => r.value is Map && r.value.containsKey(name))
      .map((r) => Result(r.value[name], r.path + expression()));

  @override
  String expression([Selector previous]) => '[${Quote(name)}]';
}
