import 'package:jessie/src/selector/selector.dart';
import 'package:jessie/src/result.dart';

class Field extends Selector {
  Field(this.name);

  final String name;

  @override
  Iterable<Result> call(Iterable<Result> results) => results
      .where((r) => r.value is Map && r.value.containsKey(name))
      .map((r) => Result(r.value[name], r.path + toString()));

  @override
  String get expression => "['$name']";
}
