import 'package:jessie/src/selector/selector.dart';
import 'package:jessie/src/result.dart';

class AllInArray extends Selector {
  @override
  Iterable<Result> call(Iterable<Result> results) =>
      results.where((r) => r.value is List).map((r) {
        final val = r.value as List;
        final results = <Result>[];
        for (var i = 0; i < val.length; i++) {
          results.add(Result(val[i], r.path + '[$i]'));
        }
        return results;
      }).expand((_) => _);

  @override
  String get expression => '[*]';
}
