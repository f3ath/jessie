import 'package:json_path/src/result.dart';
import 'package:json_path/src/selector/selector.dart';

class Index extends Selector {
  Index(this.index);

  final int index;

  @override
  Iterable<Result> call(Iterable<Result> results) => results
      .where((r) => r.value is List && r.value.length > index + 1)
      .map((r) => Result(r.value[index], r.path + toString()));

  @override
  String get expression => '[$index]';
}
