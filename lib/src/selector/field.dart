import 'package:json_path/src/quote.dart';
import 'package:json_path/src/result.dart';
import 'package:json_path/src/selector/selector.dart';

class Field extends Selector {
  Field(this.name);

  final String name;

  @override
  Iterable<Result> call(Iterable<Result> results) => results
      .where((r) => r.value is Map && r.value.containsKey(name))
      .map((r) => Result(r.value[name], r.path + toString()));

  @override
  String get expression => '[${Quote(name)}]';
}
