import 'package:jessie/src/selector/selector.dart';
import 'package:jessie/src/result.dart';

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
