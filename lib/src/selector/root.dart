import 'package:json_path/src/result.dart';
import 'package:json_path/src/selector/selector.dart';

class Root extends Selector {
  const Root();

  @override
  Iterable<Result> call(Iterable<Result> results) =>
      results.map((m) => Result(m.value, toString()));

  @override
  String get expression => r'$';
}
