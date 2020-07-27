import 'package:jessie/src/selector/selector.dart';
import 'package:jessie/src/result.dart';

class Root extends Selector {
  const Root();

  @override
  Iterable<Result> call(Iterable<Result> results) =>
      results.map((m) => Result(m.value, toString()));

  @override
  String get expression => r'$';
}
