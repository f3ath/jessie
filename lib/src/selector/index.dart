import 'package:json_path/src/result.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

class Index with SelectorMixin {
  Index(this.index);

  final int index;

  @override
  Iterable<Result> filter(Iterable<Result> results) => results
      .where((r) => r.value is List && r.value.length > index + 1)
      .map((r) => Result(r.value[index], r.path + expression()));

  @override
  String expression([Selector previous]) => '[$index]';
}
