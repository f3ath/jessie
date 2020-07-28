import 'package:jessie/src/quote.dart';
import 'package:jessie/src/result.dart';
import 'package:jessie/src/selector/selector.dart';

class Recursive extends Selector {
  @override
  Iterable<Result> call(Iterable<Result> results) => results.map((r) {
        final val = r.value;
        final self = [r];
        if (val is Map) {
          return self.followedBy(call(val.entries
              .map((e) => Result(e.value, r.path + '[${Quote(e.key)}]'))));
        }
        if (val is List) {
          return self.followedBy(call(val
              .asMap()
              .entries
              .map((e) => Result(e.value, r.path + '[${e.key}]'))));
        }
        return <Result>[];
      }).expand((_) => _);

  @override
  String get expression => '..';
}
